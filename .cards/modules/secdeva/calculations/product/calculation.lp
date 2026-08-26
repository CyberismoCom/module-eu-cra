% The solution structure records what the solution is made of. Relationships between
% products are links, never parent and child cards: product composition is a graph,
% and a component that belongs to two products cannot have two parents.

% secdeva_csafRelationship(Component, Product, Kind, Label) means that Component relates
% to Product in the way named by Kind. Label is the human-readable form used in reports.

secdeva_csafRelationship(A, B, "defaultComponentOf", "built-in component of") :-
    link(A, B, "secdeva/linkTypes/defaultComponentOf").
secdeva_csafRelationship(A, B, "externalComponentOf", "external dependency of") :-
    link(A, B, "secdeva/linkTypes/externalComponentOf").
secdeva_csafRelationship(A, B, "installedOn", "installed on") :-
    link(A, B, "secdeva/linkTypes/installedOn").
secdeva_csafRelationship(A, B, "installedWith", "installed alongside") :-
    link(A, B, "secdeva/linkTypes/installedWith").
secdeva_csafRelationship(A, B, "optionalComponentOf", "optional add-on of") :-
    link(A, B, "secdeva/linkTypes/optionalComponentOf").

% The same relationship reads differently from each end. The label in
% secdeva_csafRelationship describes the part ("optional add-on of X"); this one names
% what the part *is*, for tables that list the components of a product.

secdeva_csafPartLabel("defaultComponentOf", "built-in component").
secdeva_csafPartLabel("externalComponentOf", "external dependency").
secdeva_csafPartLabel("installedOn", "installed on this product").
secdeva_csafPartLabel("installedWith", "bundled alongside").
secdeva_csafPartLabel("optionalComponentOf", "optional add-on").

% A relationship that makes us responsible for placing a distinct product on the market.
% A default component is absorbed into the product that contains it, so it is excluded.

secdeva_distributableRelationship(P) :-
    secdeva_csafRelationship(P, _, Kind, _),
    Kind != "defaultComponentOf".

%
% The planned supply chain role
%

secdeva_placedOnMarketByUs(P) :-
    base_projectCardType(P, "secdeva/cardTypes/product"),
    not field(P, "secdeva/fieldTypes/productOrigin", "own"),
    secdeva_distributableRelationship(P),
    not link(P, _, "secdeva/linkTypes/defaultComponentOf").

% Both the role and its justification are calculated fields with an override, so they are
% emitted as fieldCalculated and the runtime suppresses either one as soon as the user
% sets it by hand.

secdeva_supplyChainRoleIsCalculated(P) :-
    base_projectCardType(P, CardType),
    calculatedField(CardType, "secdeva/fieldTypes/supplyChainRole"),
    overridableField(CardType, "secdeva/fieldTypes/supplyChainRole").

secdeva_supplyChainRoleJustificationIsCalculated(P) :-
    base_projectCardType(P, CardType),
    calculatedField(CardType, "secdeva/fieldTypes/supplyChainRoleJustification"),
    overridableField(CardType, "secdeva/fieldTypes/supplyChainRoleJustification").

% Each delivery model that places the product on the market names the role it produces
% and the reason for it.

secdeva_roleForDelivery("weDeliver", "distributor",
    "We deliver a product that is already available on the market, which makes us its distributor.").
secdeva_roleForDelivery("weImportAndDeliver", "importer",
    "We are the first to place this product on the market, from a manufacturer established outside it, which makes us its importer.").
secdeva_roleForDelivery("weRebrandAndDeliver", "manufacturer",
    "We place this product on the market under our own name, or substantially modified, which makes us its manufacturer.").

% Delivery models under which the product is never placed on the market, so no supply
% chain role arises. weOperateAsService and weConsumeAsService differ in who runs the
% software, which matters a great deal for security management but does not change
% whether the product is placed on the market.

secdeva_notPlacedOnMarketReason("customerProvides",
    "The customer provides this product. We depend on it but never place it on the market, so no supply chain role arises.").
secdeva_notPlacedOnMarketReason("weOperateAsService",
    "We run this product ourselves to operate a service rather than shipping it to anyone, so it is not placed on the market and no supply chain role arises.").
secdeva_notPlacedOnMarketReason("weConsumeAsService",
    "A third party operates this product and we use it over the network. We never run or ship it, so it is not placed on the market and no supply chain role arises.").

secdeva_notPlacedOnMarket(Delivery) :- secdeva_notPlacedOnMarketReason(Delivery, _).

% Developing a product ourselves makes us its manufacturer only if we actually place it
% on the market. A service we host is not placed on the market and carries no supply
% chain role. The role follows from the delivery model, so an own product with none
% recorded has no role yet, and the policy check below asks for one.

secdeva_ownProductNotPlacedOnMarket(P) :-
    base_projectCardType(P, "secdeva/cardTypes/product"),
    field(P, "secdeva/fieldTypes/productOrigin", "own"),
    field(P, "secdeva/fieldTypes/deliveryModel", Delivery),
    secdeva_notPlacedOnMarket(Delivery).

% secdeva_derivedRole(P, Role, Reason) pairs every derived role with the reason for it, so
% that the role and the justification shown beside it can never drift apart.

secdeva_derivedRole(P, Role, Reason) :-
    secdeva_placedOnMarketByUs(P),
    field(P, "secdeva/fieldTypes/deliveryModel", Delivery),
    secdeva_roleForDelivery(Delivery, Role, Reason).

secdeva_derivedRole(P, "manufacturer",
    "We develop this product ourselves and place it on the market, which makes us its manufacturer.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        field(P, "secdeva/fieldTypes/productOrigin", "own"),
        field(P, "secdeva/fieldTypes/deliveryModel", _),
        not secdeva_ownProductNotPlacedOnMarket(P).

secdeva_derivedRole(P, "none", Reason) :-
    secdeva_ownProductNotPlacedOnMarket(P),
    field(P, "secdeva/fieldTypes/deliveryModel", Delivery),
    secdeva_notPlacedOnMarketReason(Delivery, Reason).

secdeva_derivedRole(P, "integratedComponent",
    "This third-party component is built into one of our own products, so our manufacturer obligations for that product cover it and no separate supply chain role arises.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        not field(P, "secdeva/fieldTypes/productOrigin", "own"),
        link(P, _, "secdeva/linkTypes/defaultComponentOf").

% A third-party product we neither run nor ship. Being a built-in component of one of our
% products takes precedence, so that case is excluded here rather than deriving two roles.

secdeva_derivedRole(P, "none", Reason) :-
    base_projectCardType(P, "secdeva/cardTypes/product"),
    not field(P, "secdeva/fieldTypes/productOrigin", "own"),
    not link(P, _, "secdeva/linkTypes/defaultComponentOf"),
    field(P, "secdeva/fieldTypes/deliveryModel", Delivery),
    secdeva_notPlacedOnMarketReason(Delivery, Reason).

fieldCalculated(P, "secdeva/fieldTypes/supplyChainRole", Role) :-
    secdeva_supplyChainRoleIsCalculated(P),
    secdeva_derivedRole(P, Role, _).

fieldCalculated(P, "secdeva/fieldTypes/supplyChainRoleJustification", Reason) :-
    secdeva_supplyChainRoleJustificationIsCalculated(P),
    secdeva_derivedRole(P, _, Reason).

% Which group a product belongs to follows from its origin field, not from where the
% card happens to sit in the tree. The grouping cards are browsing containers and a
% target for the create buttons; they are not what decides anything.

secdeva_productGroup(Product, "secdeva_group_own-products") :-
    base_projectCardType(Product, "secdeva/cardTypes/product"),
    field(Product, "secdeva/fieldTypes/productOrigin", "own").

secdeva_productGroup(Product, "secdeva_group_third-party-products") :-
    base_projectCardType(Product, "secdeva/cardTypes/product"),
    field(Product, "secdeva/fieldTypes/productOrigin", Origin),
    Origin != "own".

%
% Policy checks
%

policyCheckFailure(
    P, "Solution structure", "Origin is a required field",
    "Record whether this is an own product or a third-party product.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        not field(P, "workflowStateCategory", "initial"),
        not field(P, "secdeva/fieldTypes/productOrigin", _).

policyCheckFailure(
    P, "Solution structure", "Delivery model is a required field",
    "Record what we do with this product, including who is responsible for operating it. The planned supply chain role is derived from it.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        not field(P, "workflowStateCategory", "initial"),
        not field(P, "secdeva/fieldTypes/deliveryModel", _).

policyCheckFailure(
    P, "Solution structure",
    "Justification not given for an overridden supply chain role",
    "The supply chain role has been set by hand, so the derived justification no longer describes it. Explain the role by overriding the supply chain role justification field.",
    "secdeva/fieldTypes/supplyChainRoleJustification") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        fieldOverride(P, "secdeva/fieldTypes/supplyChainRole", _),
        not fieldOverride(P, "secdeva/fieldTypes/supplyChainRoleJustification", _).

%
% Policy checks: the delivery model and the product relationships must agree
%

% A product that we never hold as an artefact cannot be packaged into our delivery. The
% customer's own copy and a service that someone else operates are both outside our
% hands, so neither can be built into a product we ship or bundled alongside one.
% weOperateAsService is deliberately absent: we do run that software, we just never ship it.

secdeva_neverInOurHands("customerProvides").
secdeva_neverInOurHands("weConsumeAsService").

secdeva_packagedRelationship("defaultComponentOf", "a built-in component of another product").
secdeva_packagedRelationship("installedWith", "bundled alongside another product").

policyCheckFailure(
    A, "Solution structure",
    "The delivery model contradicts a product relationship",
    @concatenate(
        "This product is recorded as ", RelationText,
        ", which means we ship it, but its delivery model says \"", Display,
        "\". Correct the delivery model, or record the relationship as an external dependency instead."),
    "secdeva/fieldTypes/deliveryModel") :-
        base_projectCardType(A, "secdeva/cardTypes/product"),
        secdeva_csafRelationship(A, _, Kind, _),
        secdeva_packagedRelationship(Kind, RelationText),
        field(A, "secdeva/fieldTypes/deliveryModel", Delivery),
        secdeva_neverInOurHands(Delivery),
        field(("secdeva/fieldTypes/deliveryModel", Delivery), "enumDisplayValue", Display).

% A service that a third party operates is not installed by us onto anything. The reverse
% is the ordinary platform-as-a-service case and must not be flagged: our own product
% installed on a platform that somebody else runs is exactly right.

policyCheckFailure(
    A, "Solution structure",
    "A service we consume cannot be installed on a platform",
    "This product is recorded as installed on another product, but a third party operates it and we only use it over the network. Record it as an external dependency, or reverse the platform relationship.",
    "secdeva/fieldTypes/deliveryModel") :-
        base_projectCardType(A, "secdeva/cardTypes/product"),
        link(A, _, "secdeva/linkTypes/installedOn"),
        field(A, "secdeva/fieldTypes/deliveryModel", "weConsumeAsService").

% Developing a product is something only our own organisation does.

policyCheckFailure(
    P, "Solution structure",
    "Only an own product can be developed by us",
    "The delivery model says we develop this product and place it on the market, but its origin says it comes from a third party. Correct the origin, or choose the delivery model that describes what we do with it.",
    "secdeva/fieldTypes/deliveryModel") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        field(P, "secdeva/fieldTypes/deliveryModel", "weDevelopAndDeliver"),
        not field(P, "secdeva/fieldTypes/productOrigin", "own").

% Products are assets of the project.

ismsa_asset(P, "Product") :- base_projectCardType(P, "secdeva/cardTypes/product").
ismsa_disableAssetControl(P) :- base_projectCardType(P, "secdeva/cardTypes/product").
