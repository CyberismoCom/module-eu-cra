% secdeva_defaultTitlePrefix(Identifier, Prefix) defines the beginning of the title
% when creating a card with a certain base/fieldTypes/identifier.
% The title is formed by appending the name of the project to the prefix
secdeva_defaultTitlePrefix("secdeva_test_basic-input-validation", "Basic input validation test for ").
secdeva_defaultTitlePrefix("secdeva_document_business-context-analysis", "Business context analysis for ").
secdeva_defaultTitlePrefix("secdeva_review_use-of-cryptography", "Review of the use of cryptography - ").
secdeva_defaultTitlePrefix("secdeva_review_manage-defects", "Review of defect management - ").
secdeva_defaultTitlePrefix("secdeva_document_design-specification", "Design specification - ").
secdeva_defaultTitlePrefix("secdeva_review_protect-environments", "Review of environment protection for ").
secdeva_defaultTitlePrefix("secdeva_test_error-handling", "Error handling test for ").
secdeva_defaultTitlePrefix("secdeva_test_known-vulnerability", "Known vulnerability scanning of ").
secdeva_defaultTitlePrefix("secdeva_document_management-plan", "Management plan for ").
secdeva_defaultTitlePrefix("secdeva_review_manual-code-review", "Review of manual code review practices - ").
secdeva_defaultTitlePrefix("secdeva_review_static-code-analysis", "Review of static code analysis - ").
secdeva_defaultTitlePrefix("secdeva_document_security-context", "Security context for ").
secdeva_defaultTitlePrefix("secdeva_document_security-requirement-specification", "Security requirement specification for ").
secdeva_defaultTitlePrefix("secdeva_test_security-requirements", "Security requirements test for ").
secdeva_defaultTitlePrefix("secdeva_review_vulnerability-management", "Vulnerability management for ").
secdeva_defaultTitlePrefix("secdeva_test_threat-mitigation", "Threat mitigation test for ").
secdeva_defaultTitlePrefix("secdeva_document_threat-model", "Threat model for ").
secdeva_defaultTitlePrefix("secdeva_review_software-update-management", "Review of software update management for ").

onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(Prefix, ProjectName)) :-
    field(Card, "base/fieldTypes/identifier", Identifier),
    secdeva_defaultTitlePrefix(Identifier, Prefix),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).

% The default title for periodic review includes today's date:
onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(@today, " Periodic review for ", ProjectName)) :-
    field(Card, "base/fieldTypes/identifier", "secdeva_review_periodic"),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).
