ismsa_asset(Card, "Development project") :-
    base_projectCardType(Card, "secdeva/cardTypes/project").

secdeva_closestProject(Project, Project) :-
    base_projectCardType(Project, "secdeva/cardTypes/project").

secdeva_closestProject(Card, Project) :-
    base_projectCardType(Project, "secdeva/cardTypes/project"),
    not base_projectCardType(Card, "secdeva/cardTypes/project"),
    ancestor(Card, Project),
    not base_projectCardType(MiddleAncestor, "secdeva/cardTypes/project") :
    ancestor(MiddleAncestor, Project),
    ancestor(Card, MiddleAncestor).

% Usually, ismsa/fieldTypes/assetRiskEvaluationNeeded is a user-defined field of an asset,
% but for development projects, we can calculate it based on the risk assessment task
field(Project, "ismsa/fieldTypes/assetRiskEvaluationNeeded", "yes") :-
    base_projectCardType(Project, "secdeva/cardTypes/project"),
    secdeva_closestProject(RiskAssessment, Project),
    field(RiskAssessment, "base/fieldTypes/identifier", "secdeva_control_high-level-risks"),
    field(RiskAssessment, "workflowState", State),
    secdeva_scopingStatus(State, "In scope").

field(Project, "ismsa/fieldTypes/assetRiskEvaluationNeeded", "no") :-
    base_projectCardType(Project, "secdeva/cardTypes/project"),
    secdeva_closestProject(RiskAssessment, Project),
    field(RiskAssessment, "base/fieldTypes/identifier", "secdeva_control_high-level-risks"),
    field(RiskAssessment, "workflowState", State),
    secdeva_scopingStatus(State, "Out of scope").

% Backups is a mandatory field for development projects
policyCheckFailure(Asset, "ISMS", "'Backup(s)' is a required field", "'Backup(s)' has not been defined for this asset. Set this field.") :-
    base_projectCardType(Asset, "secdeva/cardTypes/project"),
    not field(Asset, "ismsa/fieldTypes/assetBackups", _).

% We are storing risks in a subcard, so we need a dedicated automated link
link(DevelopmentProject, Risk, "ismsa/linkTypes/presentsRisk") :-
    base_projectCardType(DevelopmentProject, "secdeva/cardTypes/project"),
    base_projectCardType(Risk, "ismsa/cardTypes/risk"),
    parent(Risk, RiskTask),
    secdeva_closestProject(RiskTask, DevelopmentProject),
    field(RiskTask, "base/fieldTypes/identifier", "secdeva_control_high-level-risks").