% secdeva_evidence declares that a certain identifier is evidence of a certain task:
% secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceTitle)

link(Evidence, Task, "secdeva/linkTypes/evidences") :-
    secdeva_closestProject(Task, Project),
    secdeva_closestProject(Evidence, Project),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, _),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier).

secdeva_evidence("secdeva_control_management-plan", "secdeva_document_management-plan", "Management plan").
secdeva_evidence("secdeva_control_threat-models", "secdeva_document_threat-model", "Threat model").
secdeva_evidence("secdeva_control_assign-people-to-project-roles", "secdeva_document_project-role-assignments", "Project role assignments").
secdeva_evidence("secdeva_control_analyse-business-context", "secdeva_document_business-context-analysis", "Business context analysis").
secdeva_evidence("secdeva_control_security-context", "secdeva_document_security-context", "Security context").
secdeva_evidence("secdeva_control_interface-specifications", "secdeva_document_interface", "Interface description").
secdeva_evidence("secdeva_control_static-code-analysis", "secdeva_review_static-code-analysis", "Review of \nstatic code analysis").
secdeva_evidence("secdeva_control_manual-code-review", "secdeva_review_manual-code-review", "Review of \nmanual code review").
secdeva_evidence("secdeva_control_threat-mitigation-testing", "secdeva_test_threat-mitigation", "Review of \nthreat mitigation testing").
secdeva_evidence("secdeva_control_security-requirements", "secdeva_document_security-requirement-specification", "Security requirements specification").
secdeva_evidence("secdeva_control_security-requirement-testing", "secdeva_test_security-requirements", "Review of \nsecurity requirement testing").
secdeva_evidence("secdeva_control_3rd-party-technologies", "secdeva_document_technology", "Technology description").
secdeva_evidence("secdeva_control_vulnerability-management", "secdeva_review_vulnerability-management", "Review of 3rd party \nvulnerability management").
secdeva_evidence("secdeva_control_software-update-management", "secdeva_review_software-update-management", "Review of 3rd party \nsoftware update management").
secdeva_evidence("secdeva_control_use-of-cryptography", "secdeva_review_use-of-cryptography", "Review of \nthe use of cryptograpy").
secdeva_evidence("secdeva_control_protect-environments", "secdeva_review_protect-environments", "Review of\nprotecting environments").
secdeva_evidence("secdeva_control_known-vulnerability-scanning", "secdeva_test_known-vulnerability", "Review of \nknown vulnerability scanning").
secdeva_evidence("secdeva_control_basic-input-validation-testing", "secdeva_test_basic-input-validation", "Review of \ninput validation testing").
secdeva_evidence("secdeva_control_error-handling-testing", "secdeva_test_error-handling", "Review of \nerror handling testing").
secdeva_evidence("secdeva_control_manage-defects", "secdeva_review_manage-defects", "Review of defect management").

% secdeva_evidenceByCardType declares that a certain card type is evidence of a certain task:
% secdeva_evidenceByCardType(TaskIdentifier, EvidenceCardType, EvidenceTitle)

link(Evidence, Task, "secdeva/linkTypes/evidences") :-
    secdeva_closestProject(Task, Project),
    secdeva_closestProject(Evidence, Project),
    secdeva_evidenceByCardType(TaskIdentifier, EvidenceCardType, _),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    field(Evidence, "cardType", EvidenceCardType).

secdeva_evidenceByCardType("secdeva_control_assign-people-to-project-roles", "base/cardTypes/roleAssignment", "Role assignment").
secdeva_evidenceByCardType("secdeva_control_high-level-risks", "ismsa/cardTypes/risk", "Risk").
