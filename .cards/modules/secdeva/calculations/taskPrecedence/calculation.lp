
link(First, Second, "secdeva/linkTypes/precedes") :-
    not hiddenInTreeView(First),
    not hiddenInTreeView(Second),
    secdeva_closestProject(First, Project),
    secdeva_closestProject(Second, Project),
    field(First, "base/fieldTypes/identifier", FirstIdentifier),
    field(Second, "base/fieldTypes/identifier", SecondIdentifier),
    secdeva_precedingTask(FirstIdentifier, SecondIdentifier).

link(Second, First, "secdeva/linkTypes/requires") :-
    not hiddenInTreeView(First),
    not hiddenInTreeView(Second),
    secdeva_closestProject(First, Project),
    secdeva_closestProject(Second, Project),
    field(First, "base/fieldTypes/identifier", FirstIdentifier),
    field(Second, "base/fieldTypes/identifier", SecondIdentifier),
    secdeva_prerequisiteTask(FirstIdentifier, SecondIdentifier).

link(First, Second, "ismsa/linkTypes/implements") :-
    not hiddenInTreeView(First),
    not hiddenInTreeView(Second),
    secdeva_closestProject(First, Project),
    secdeva_closestProject(Second, Project),
    field(First, "base/fieldTypes/identifier", FirstIdentifier),
    field(Second, "base/fieldTypes/identifier", SecondIdentifier),
    secdeva_implementationTask(FirstIdentifier, SecondIdentifier).

secdeva_prerequisiteTask(
    "secdeva_control_assign-people-to-project-roles",
    "secdeva_control_ensure-competence").

% Legacy fact:
secdeva_precedingTask(
    "secdeva_control_analyse-business-context",
    "secdeva_control_high-level-risks").

secdeva_prerequisiteTask(
    "secdeva_control_security-context",
    "secdeva_control_high-level-risks").

secdeva_precedingTask(
    "secdeva_control_threat-models",
    "secdeva_control_high-level-risks").

secdeva_prerequisiteTask(
    "secdeva_control_security-context",
    "secdeva_control_threat-models").

% Legacy fact: the interfaces control moved to secdevb. This remains only for the
% deprecated secdeva/templates/project (v1), which still ships that control card.
secdeva_prerequisiteTask(
    "secdeva_control_threat-models",
    "secdeva_control_interface-specifications").

secdeva_prerequisiteTask(
    "secdeva_control_threat-models",
    "secdeva_control_threat-mitigation-testing").

secdeva_precedingTask(
    "secdeva_control_threat-models",
    "secdeva_control_security-requirements").

secdeva_precedingTask(
    "secdeva_control_high-level-risks",
    "secdeva_control_security-requirements").

secdeva_precedingTask(
    "secdeva_control_high-level-risks",
    "secdeva_control_scope-secure-development-activities").

secdeva_prerequisiteTask(
    "secdeva_control_security-requirements",
    "secdeva_control_security-requirement-testing").

secdeva_prerequisiteTask(
    "secdeva_control_high-level-risks",
    "secdeva_control_risk-mitigation-testing").

secdeva_precedingTask(
    "secdeva_control_security-requirement-testing",
    "secdeva_control_risk-mitigation-testing").

secdeva_prerequisiteTask(
    "secdeva_control_3rd-party-technologies",
    "secdeva_control_vulnerability-management").

secdeva_prerequisiteTask(
    "secdeva_control_3rd-party-technologies",
    "secdeva_control_software-update-management").

secdeva_prerequisiteTask(
    "secdeva_control_threat-models",
    "secdeva_control_security-design-review").

secdeva_prerequisiteTask(
    "secdeva_control_document-attack-surface",
    "secdeva_control_attack-surface-analysis").

secdeva_precedingTask(
    "secdeva_control_attack-surface-analysis",
    "secdeva_control_penetration-testing").

secdeva_prerequisiteTask(
    "secdeva_control_use-of-cryptography",
    "secdeva_control_integrity-protection-of-release").


