editingContentDenied(InternalControl, "Internal controls are read-only") :-
  field(InternalControl, "cardType", "ismsa/cardTypes/internalControl"),
  ancestor(InternalControl, DevelopmentProject),
  field(DevelopmentProject, "cardType", "secdeva/cardTypes/project2").

% Internal controls that are required by default

secdeva_controlInScopeByDefault("secdeva_control_assign-people-to-project-roles").
secdeva_controlInScopeByDefault("secdeva_control_security-context").
secdeva_controlInScopeByDefault("secdeva_control_threat-models").
secdeva_controlInScopeByDefault("secdeva_control_high-level-risks").
secdeva_controlInScopeByDefault("secdeva_control_scope-secure-development-activities").
secdeva_controlInScopeByDefault("secdeva_control_3rd-party-technologies").
secdeva_controlInScopeByDefault("secdeva_control_security-design-review").
secdeva_controlInScopeByDefault("secdeva_control_manage-defects").
secdeva_controlInScopeByDefault("secdeva_control_basic-input-validation-testing").
secdeva_controlInScopeByDefault("secdeva_control_error-handling-testing").
secdeva_controlInScopeByDefault("secdeva_control_attack-surface-analysis").
secdeva_controlInScopeByDefault("secdeva_control_vulnerability-management").
secdeva_controlInScopeByDefault("secdeva_control_protect-environments").

onTransitionExecuteTransition(Control, "Create", Control, "Mark in scope") :-
  field(Control, "base/fieldTypes/identifier", Identifier),
  secdeva_controlInScopeByDefault(Identifier).
  