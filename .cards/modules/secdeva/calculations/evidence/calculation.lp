% secdeva_evidence declares that a certain identifier is evidence of a certain task:
% secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceTitle)

link(Evidence, Task, "ismsa/linkTypes/evidences") :-
  secdeva_closestProject(Task, Project),
  secdeva_closestProject(Evidence, Project),
  secdeva_evidence(TaskIdentifier, EvidenceIdentifier, _),
  field(Task, "base/fieldTypes/identifier", TaskIdentifier),
  field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier).

% TODO: the secdeva_legacyEvidence facts support backwards compatibility to content
% that has been created from old versions of the development project template.
% These facts and the corresponding rule below can be removed, once there are no more users for the old content

link(Evidence, Task, "ismsa/linkTypes/evidences") :-
  secdeva_closestProject(Task, Project),
  secdeva_closestProject(Evidence, Project),
  secdeva_legacyEvidence(TaskIdentifier, EvidenceIdentifier, _),
  field(Project, "cardType", "secdeva/cardTypes/project"),
  field(Task, "base/fieldTypes/identifier", TaskIdentifier),
  field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier).

secdeva_evidence("secdeva_control_management-plan", "secdeva_document_management-plan", "Management plan").
secdeva_evidence("secdeva_control_threat-models", "secdeva_document_threat-model", "Threat model").
secdeva_evidence("secdeva_control_high-level-risks", "secdeva_review_risk-management", "Review of risk management").
secdeva_evidence("secdeva_control_high-level-risks", "secdeva_register_risks", "Risk register").
secdeva_legacyEvidence("secdeva_control_assign-people-to-project-roles", "secdeva_document_project-role-assignments", "Project role assignments").
secdeva_evidence("secdeva_control_assign-people-to-project-roles", "secdeva_review_project-role-assignments", "Project role assignments").
secdeva_evidence("secdeva_control_ensure-competence", "secdeva_review_competence", "Competence review").
secdeva_evidence("secdeva_control_analyse-business-context", "secdeva_document_business-context-analysis", "Business context analysis").
secdeva_evidence("secdeva_control_security-context", "secdeva_document_security-context", "Security context").
secdeva_evidence("secdeva_control_interface-specifications", "secdeva_document_interface", "Interface description").
secdeva_evidence("secdeva_control_interface-specifications", "secdeva_review_interfaces", "Review of interfaces").
secdeva_evidence("secdeva_control_subprojects", "secdeva_review_project-structure", "Project structure review").
secdeva_evidence("secdeva_control_static-code-analysis", "secdeva_review_static-code-analysis", "Review of \nstatic code analysis").
secdeva_evidence("secdeva_control_manual-code-review", "secdeva_review_manual-code-review", "Review of \nmanual code review").
secdeva_evidence("secdeva_control_threat-mitigation-testing", "secdeva_test_threat-mitigation", "Review of \nthreat mitigation testing").
secdeva_legacyEvidence("secdeva_control_security-requirements", "secdeva_document_security-requirement-specification", "Security requirements specification").
secdeva_evidence("secdeva_control_security-requirements", "secdeva_review_requirement-management", "Review of \nsecurity requirements management").
secdeva_evidence("secdeva_control_security-requirements", "secdeva_register_security-requirements", "Security requirement register").
secdeva_legacyEvidence("secdeva_control_security-requirement-testing", "secdeva_test_security-requirements", "Review of \nsecurity requirement testing").
secdeva_evidence("secdeva_control_security-requirement-testing", "secdeva_review_security-requirement-testing", "Review of \nsecurity requirement testing").
secdeva_evidence("secdeva_control_3rd-party-technologies", "secdeva_register_technology-assessments", "Technology assessments").
secdeva_evidence("secdeva_control_3rd-party-technologies", "secdeva_review_3rd-party-technologies", "Review of 3rd party technologies").
secdeva_evidence("secdeva_control_vulnerability-management", "secdeva_review_vulnerability-management", "Review of 3rd party \nvulnerability management").
secdeva_evidence("secdeva_control_software-update-management", "secdeva_review_software-update-management", "Review of 3rd party \nsoftware update management").
secdeva_legacyEvidence("secdeva_control_use-of-cryptography", "secdeva_review_use-of-cryptography", "Review of \nthe use of cryptograpy").
secdeva_evidence("secdeva_control_use-of-cryptography", "secdeva_document_use-of-cryptography", "Use of cryptograpy document").
secdeva_evidence("secdeva_control_protect-environments", "secdeva_review_protect-environments", "Review of\nprotecting environments").
secdeva_evidence("secdeva_control_known-vulnerability-scanning", "secdeva_test_known-vulnerability", "Review of \nknown vulnerability scanning").
secdeva_evidence("secdeva_control_basic-input-validation-testing", "secdeva_test_basic-input-validation", "Review of \ninput validation testing").
secdeva_evidence("secdeva_control_error-handling-testing", "secdeva_test_error-handling", "Review of \nerror handling testing").
secdeva_evidence("secdeva_control_manage-defects", "secdeva_review_manage-defects", "Review of defect management").
secdeva_evidence("secdeva_control_configuration-management-plan", "secdeva_document_configuration-management-plan", "Configuration management plan").

secdeva_evidence("secdeva_control_scope-secure-development-activities", "secdeva_review_process-scoping", "Review of process scoping").

secdeva_evidence("secdeva_control_security-design-review", "secdeva_review_security-design", "Security design review").
secdeva_evidence("secdeva_control_privacy-by-design-review", "secdeva_review_privacy-by-design", "Privacy by design review").
secdeva_evidence("secdeva_control_document-attack-surface", "secdeva_document_attack-surface", "Attack surface specification").
secdeva_evidence("secdeva_control_product-documentation-review", "secdeva_review_product-documentation", "Product documentation review").
secdeva_evidence("secdeva_control_integrity-protection-of-release", "secdeva_review_integrity-protection-of-release", "Review of \nrelease integrity protection").
secdeva_evidence("secdeva_control_attack-surface-analysis", "secdeva_review_attack-surface", "Attack surface analysis").
secdeva_evidence("secdeva_control_penetration-testing", "secdeva_test_penetration", "Penetration test").


% TODO: the rule about individual role assignments "base/cardTypes/roleAssignment" supports backwards
% compatibility to content that has been created from old versions of the development project template.
% In the old content format, role assignments were created directly under the control
% This rule can be removed, once there are no more users for the old content
link(RoleAssignment, Task, "ismsa/linkTypes/evidences") :-
  secdeva_closestProject(Task, Project),
  secdeva_closestProject(RoleAssignment, Project),
  field(Task, "base/fieldTypes/identifier", "secdeva_control_assign-people-to-project-roles"),
  field(RoleAssignment, "cardType", "base/cardTypes/roleAssignment"),
  parent(RoleAssignment, RoleAssignments),
  field(RoleAssignments, "base/fieldTypes/identifier", "secdeva_control_assign-people-to-project-roles").


% TODO: the following rule supports backwards compatibility to legacy content
link(Evidence, Task, "ismsa/linkTypes/evidences") :-
  secdeva_closestProject(Task, Project),
  secdeva_closestProject(Evidence, Project),
  field(Project, "cardType", "secdeva/cardTypes/project"),
  field(Task, "base/fieldTypes/identifier", "secdeva_control_high-level-risks"),
  field(Evidence, "cardType", "ismsa/cardTypes/risk").

ismsa_internalControlMissingEvidence(Task) :-
  secdeva_evidence(TaskIdentifier, EvidenceIdentifier, _),
  field(Task, "base/fieldTypes/identifier", TaskIdentifier),
  link(_, Task, "ismsa/linkTypes/evidences"),
  not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
  link(Evidence, Task, "ismsa/linkTypes/evidences").
