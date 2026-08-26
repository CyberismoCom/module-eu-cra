% secdeva_calculateProgress(Card) means that we want Card to show a progress metric
% secdeva_includeInProgressCalculation(Card) means that Card should be considered as part of the metric
% secdeva_isAcceptableInProgressCalculation(Card) means that Card is OK or not applicable and raises the metric

% Include recurring tasks and internal controls in progress calculation
secdeva_includeInProgressCalculation(Task) :- base_recurringTask(Task).
secdeva_includeInProgressCalculation(Control) :- base_projectCardType(Control, "ismsa/cardTypes/internalControl").

% Closed tasks are considered acceptable
secdeva_isAcceptableInProgressCalculation(Task) :- 
    field(Task, "workflowStateCategory", "closed"),
    base_recurringTask(Task).

% internal controls are acceptable if the assessment is OK or Not applicable
secdeva_isAcceptableInProgressCalculation(Control) :- 
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "base/fieldTypes/assessment", "ok").

secdeva_isAcceptableInProgressCalculation(Control) :- 
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "base/fieldTypes/assessment", "notApplicable").

% calculate progress for the entire project
secdeva_calculateProgress(Project) :-
    base_projectCardType(Project, "secdeva/cardTypes/project").
secdeva_calculateProgress(Project) :-
    base_projectCardType(Project, "secdeva/cardTypes/project2").

% calculate progress for internal control registers
secdeva_calculateProgress(ControlRegister) :-
    base_projectCardType(ControlRegister, "ismsa/cardTypes/register"),
    field(ControlRegister, "ismsa/fieldTypes/progress", "secdeva_internal-control-progress").

% copy progress metric from control registers to phase pages
secdeva_copyProgressMetric("secdeva_register_foundation-controls", "secdeva_phase_foundation").
secdeva_copyProgressMetric("secdeva_register_design-controls", "secdeva_phase_design").
secdeva_copyProgressMetric("secdeva_register_implementation-controls", "secdeva_phase_implementation").
secdeva_copyProgressMetric("secdeva_register_verification-controls", "secdeva_phase_verification").
secdeva_copyProgressMetric("secdeva_register_releases-controls", "secdeva_phase_releases").
secdeva_copyProgressMetric("secdeva_register_operations-controls", "secdeva_phase_operations").

field(Phase, "base/fieldTypes/progress", Progress) :-
    secdeva_closestProject(Phase, Project),
    secdeva_closestProject(ControlRegister, Project),
    field(Phase, "ismsa/fieldTypes/progress", "secdeva_phase-progress"),
    field(ControlRegister, "base/fieldTypes/progress", Progress),
    field(Phase, "base/fieldTypes/identifier", PhaseIdentifier),
    field(ControlRegister, "base/fieldTypes/identifier", ControlRegisterIdentifier),
    secdeva_copyProgressMetric(ControlRegisterIdentifier, PhaseIdentifier).

% calculate progress for phase pages that were created as part of 
% the previous version of the project template
% TODO: this rule can be removed once there are no users for the old project format
secdeva_calculateProgress(Phase) :-
    base_projectCardType(Phase, "secdeva/cardTypes/page"),
    ancestor(Task, Phase),
    secdeva_includeInProgressCalculation(Task).

field(Card, "base/fieldTypes/progress", 100 * Closed / Total) :-
    secdeva_calculateProgress(Card),
    secdeva_closestProject(Card, Project),
    Total = #count {
        card(Task) :
        ancestor(Task, Card),
        secdeva_includeInProgressCalculation(Task),
        not base_greaterAdoptionStep(Task, Project)
    },
    Total > 0,
    Closed = #count {
        card(Task) :
        secdeva_includeInProgressCalculation(Task),
        ancestor(Task, Card),
        secdeva_isAcceptableInProgressCalculation(Task),
        not base_greaterAdoptionStep(Task, Project)
    }.

policyCheckFailure(
    Project,
    "Secure development",
    "Secure development tasks are not complete",
    @concatenate("Only ", Progress, "% of secure development tasks have been completed. Complete all tasks or close them as not applicable.")
    ) :-
        base_projectCardType(Project, "secdeva/cardTypes/project"),
        field(Project, "base/fieldTypes/progress", Progress),
        Progress < 100.

policyCheckSuccess(
    Project,
    "Secure development",
    "Secure development tasks are complete"
    ) :-
        base_projectCardType(Project, "secdeva/cardTypes/project"),
        field(Project, "base/fieldTypes/progress", 100).
