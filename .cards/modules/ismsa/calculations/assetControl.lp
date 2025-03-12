ismsa_asset(Card) :- ismsa_asset(Card, _).

ismsa_asset(Card, "Asset") :-
    field(Card, "cardType", "ismsa/cardTypes/asset").

ismsa_asset(Card, "Information system") :-
    field(Card, "cardType", "ismsa/cardTypes/assetInformationSystem").

ismsa_asset(Card, "Data asset") :-
    field(Card, "cardType", "ismsa/cardTypes/assetData").

ismsa_asset(Card, "Device") :-
    field(Card, "cardType", "ismsa/cardTypes/assetDevice").

ismsa_asset(Card, "Supplier") :-
    field(Card, "cardType", "ismsa/cardTypes/assetSupplier").

% Criticality and risk evaluation needed are mandatory for all assets
% Risk evaluation needed can be a calculated field
policyCheckFailure(Asset, "ISMS", "'Criticality for operations' is a required field", "'Criticality for operations' has not been defined for this asset. Set this field.") :-
    ismsa_asset(Asset),
    not field(Asset, "ismsa/fieldTypes/assetCriticalityForOperations", _).

policyCheckFailure(Asset, "ISMS", "'Risk evaluation needed' is a required field", "'Risk evaluation needed' has not been defined for this asset. Set this field.") :-
    ismsa_asset(Asset),
    not field(Asset, "ismsa/fieldTypes/assetRiskEvaluationNeeded", _),
    field(Asset, "cardType", CardType),
    not calculatedField(CardType, "ismsa/fieldTypes/assetRiskEvaluationNeeded").

% Access control, backup(s), security updates and logging & monitoring are mandatory for information systems
policyCheckFailure(Asset, "ISMS", "'Access control' is a required field", "'Access control' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetAccessControl", _).

policyCheckFailure(Asset, "ISMS", "'Security updates' is a required field", "'Security updates' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetUpdates", _).

policyCheckFailure(Asset, "ISMS", "'Backup(s)' is a required field", "'Backup(s)' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetBackups", _).

policyCheckFailure(Asset, "ISMS", "'Logging and monitoring' is a required field", "'Logging and monitoring' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetLoggingAndMonitoring", _).

% Integrity, availability and personal data classification and location are mandatory for data assets
policyCheckFailure(Asset, "ISMS", "'Integrity' is a required field", "'Integrity' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetIntegrity", _).

policyCheckFailure(Asset, "ISMS", "'Availability' is a required field", "'Availability' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetAvailability", _).

policyCheckFailure(Asset, "ISMS", "'Contains personal information' is a required field", "'Contains personal information' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetPersonalInformation", _).

policyCheckFailure(Asset, "ISMS", "'Location' is a required field", "'Location' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetLocation", _).

% Access control, backup(s) and security updates are mandatory for devices
policyCheckFailure(Asset, "ISMS", "'Access control' is a required field", "'Access control' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetAccessControl", _).

policyCheckFailure(Asset, "ISMS", "'Backup(s)' is a required field", "'Backup(s)' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetBackups", _).

policyCheckFailure(Asset, "ISMS", "'Security updates' is a required field", "'Security updates' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetUpdates", _).

% Provided service and contact details are mandatory for suppliers
policyCheckFailure(Asset, "ISMS", "'Provided services' is a required field", "'Provided services' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetSupplier"),
    not field(Asset, "ismsa/fieldTypes/assetProvidedServices", _).

policyCheckFailure(Asset, "ISMS", "'Contact details' is a required field", "'Contact details' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetSupplier"),
    not field(Asset, "ismsa/fieldTypes/assetContactDetails", _).

transitionDenied(Asset, "Activate", "Nominate owner before activating" ):-
    ismsa_asset(Asset),
    not field(Asset, "base/fieldTypes/owner", _).

% At least one risk needs to be linked, if risk evaluation is needed
policyCheckFailure(Asset, "ISMS", "Risks must be reported if risk evaluation is needed", "Risk evaluation is needed for this asset, but no risks have been reported. Link this asset to one or more risks.") :-
    ismsa_asset(Asset),
    field(Asset, "ismsa/fieldTypes/assetRiskEvaluationNeeded", "yes"),
    not link(Asset, _, "ismsa/linkTypes/presentsRisk").