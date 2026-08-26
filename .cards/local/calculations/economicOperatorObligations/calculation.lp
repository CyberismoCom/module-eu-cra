% The secure development module records the product structure and derives the planned
% economic operator role from the delivery model. What that role *obliges* us to do is
% EU product legislation, so it belongs here rather than in the generic module.

% A distributor and an importer both have to verify that the product carries the CE
% marking and that the manufacturer can be reached, neither of which is possible without
% knowing who the manufacturer is.
%
% This reads field/3 rather than fieldCalculated/3 on purpose. field/3 carries the
% effective value: base.lp derives it from fieldOverride, and the data handler bridges
% fieldCalculated into it only when no override exists. The obligation follows from the
% role the product actually has, so a role set by hand has to count too.

eucra_roleNeedsVendor("distributor").
eucra_roleNeedsVendor("importer").

policyCheckFailure(
    P, "EU Cyber Resilience Act", "A distributor or importer needs a known vendor",
    "Both roles carry obligations to verify conformity marking and to reach the manufacturer. Record the vendor.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        field(P, "secdeva/fieldTypes/supplyChainRole", Role),
        eucra_roleNeedsVendor(Role),
        not field(P, "secdeva/fieldTypes/productVendor", _).

% Placing a product on the market under your own name or trademark, or modifying it
% substantially, transfers the full manufacturer obligations to you. Somebody has to be
% accountable for them.

policyCheckFailure(
    P, "EU Cyber Resilience Act", "Placing a product under our own name makes us its manufacturer",
    "This product is delivered under our own name or substantially modified, which makes us the manufacturer. Assign an owner who is accountable for the manufacturer obligations.") :-
        base_projectCardType(P, "secdeva/cardTypes/product"),
        field(P, "secdeva/fieldTypes/deliveryModel", "weRebrandAndDeliver"),
        not field(P, "base/fieldTypes/owner", _).
