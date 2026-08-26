% secdeva_defaultTitle(Identifier, Prefix) defines the beginning of the title
% when creating a card with a certain base/fieldTypes/identifier.
% The title is formed by appending the name of the project to the prefix

% secdeva_defaultTitleWithDate(Identifier, Prefix) defines the beginning of the title
% when creating a card with a certain base/fieldTypes/identifier.
% The title is formed by the prefix to today's date and then appending the name of the project


secdeva_defaultTitleWithDate("secdeva_test_basic-input-validation", "Review of basic input validation testing - ").
secdeva_defaultTitle("secdeva_document_business-context-analysis", "Business context analysis - "). % Legacy
secdeva_defaultTitleWithDate("secdeva_review_use-of-cryptography", "Review of the use of cryptography - ").
secdeva_defaultTitleWithDate("secdeva_document_use-of-cryptography", "Use of cryptography - ").
secdeva_defaultTitleWithDate("secdeva_review_process-scoping", "Review of process scoping - ").

secdeva_defaultTitleWithDate("secdeva_review_manage-defects", "Review of security issue management - ").
secdeva_defaultTitle("secdeva_document_design-specification", "Design specification - ").
secdeva_defaultTitleWithDate("secdeva_review_protect-environments", "Review of environment protection - ").
secdeva_defaultTitleWithDate("secdeva_test_error-handling", "Review of error handling testing - ").
secdeva_defaultTitleWithDate("secdeva_test_known-vulnerability", "Review of known vulnerability scanning - ").
secdeva_defaultTitle("secdeva_document_configuration-management-plan", "Configuration management plan - "). % Legacy
secdeva_defaultTitleWithDate("secdeva_review_manual-code-review", "Review of manual code review practices - ").
secdeva_defaultTitleWithDate("secdeva_review_static-code-analysis", "Review of static code analysis - ").
secdeva_defaultTitle("secdeva_document_security-context", "Security context - ").
secdeva_defaultTitleWithDate("secdeva_review_requirement-management", "Review of security requirement management - ").
secdeva_defaultTitleWithDate("secdeva_test_security-requirements", "Security requirement test - ").
secdeva_defaultTitleWithDate("secdeva_review_security-requirement-testing", "Review of security requirement testing - ").
secdeva_defaultTitleWithDate("secdeva_review_risk-mitigation-testing", "Review of risk mitigation testing - ").
secdeva_defaultTitleWithDate("secdeva_review_vulnerability-management", "Review of vulnerability management - ").
secdeva_defaultTitle("secdeva_test_threat-mitigation", "Threat mitigation test - ").
secdeva_defaultTitle("secdeva_document_threat-model", "Threat model - ").
secdeva_defaultTitle("secdeva_document_dataflow-model", "Dataflow model - ").
secdeva_defaultTitleWithDate("secdeva_review_software-update-management", "Review of software update management - ").
secdeva_defaultTitle("secdeva_review_project-role-assignments", "Role assignments - ").
secdeva_defaultTitleWithDate("secdeva_review_project-structure", "Review of project structure - ").
secdeva_defaultTitleWithDate("secdeva_review_competence", "Competence review - ").
secdeva_defaultTitleWithDate("secdeva_review_periodic", "Periodic review - ").
secdeva_defaultTitleWithDate("secdeva_review_3rd-party-technologies", "Review of third-party technologies - ").
secdeva_defaultTitleWithDate("secdeva_review_risk-management", "Review of risk management - ").
secdeva_defaultTitleWithDate("secdeva_review_interfaces", "Review of interfaces - "). % Legacy
secdeva_defaultTitleWithDate("secdeva_review_process-scoping", "Review of process scoping - ").

secdeva_defaultTitleWithDate("secdeva_review_security-design", "Review of security design - ").
secdeva_defaultTitleWithDate("secdeva_review_privacy-by-design", "Review of privacy by design - ").
secdeva_defaultTitle("secdeva_document_attack-surface", "Attack surface specification - ").
secdeva_defaultTitleWithDate("secdeva_review_product-documentation", "Review of product documentation - ").
secdeva_defaultTitleWithDate("secdeva_review_integrity-protection-of-release", "Review of release integrity protection - ").
secdeva_defaultTitleWithDate("secdeva_review_attack-surface", "Review of attack surface analysis - ").
secdeva_defaultTitleWithDate("secdeva_test_penetration", "Penetration test - ").


onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(Prefix, ProjectName)
) :-
    field(Card, "base/fieldTypes/identifier", Identifier),
    secdeva_defaultTitle(Identifier, Prefix),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).

onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(@today, " ", Prefix, ProjectName)
) :-
    field(Card, "base/fieldTypes/identifier", Identifier),
    secdeva_defaultTitleWithDate(Identifier, Prefix),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).
