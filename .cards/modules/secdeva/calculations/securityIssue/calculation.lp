transitionDenied(
    Issue,
    "Analyse",
    "Set severity before analysing the issue"
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "secdeva/fieldTypes/severity", _).

policyCheckFailure(Issue, "Secure development", "Severity is required", "Severity is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "workflowStateCategory", "initial"),
        not field(Issue, "secdeva/fieldTypes/severity", _).

transitionDenied(
    Issue,
    "Analyse",
    "Set root cause category before analysing the issue"
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "secdeva/fieldTypes/rootCauseCategory", _).

policyCheckFailure(Issue, "Secure development", "Root cause category is required", "Root cause category is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "workflowStateCategory", "initial"),
        not field(Issue, "secdeva/fieldTypes/rootCauseCategory", _).

transitionDenied(
    Issue,
    "Analyse",
    "Set the Reporting field before analysing the issue"
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "secdeva/fieldTypes/reporting", _).

policyCheckFailure(Issue, "Secure development", "Reporting is required", "Reporting is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "workflowStateCategory", "initial"),
        not field(Issue, "secdeva/fieldTypes/reporting", _).

transitionDenied(
    Issue,
    "Fix required",
    "Set the Strategy field before transitioning to 'Fix required'"
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

policyCheckFailure(Issue, "Secure development", "Strategy is required", "Strategy is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "workflowState", "Fix required"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

policyCheckFailure(Issue, "Secure development", "Strategy is required", "Strategy is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "workflowState", "Fix deferred"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

policyCheckFailure(Issue, "Secure development", "Strategy is required", "Strategy is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "workflowState", "In progress"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

policyCheckFailure(Issue, "Secure development", "Strategy is required", "Strategy is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "workflowState", "To be verified"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

policyCheckFailure(Issue, "Secure development", "Strategy is required", "Strategy is a required field.") :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "workflowState", "Closed as verified"),
        not field(Issue, "secdeva/fieldTypes/strategy", _).

secdeva_severityLessThan("none", "low").
secdeva_severityLessThan("none", "medium").
secdeva_severityLessThan("none", "high").
secdeva_severityLessThan("none", "critical").
secdeva_severityLessThan("low", "medium").
secdeva_severityLessThan("low", "high").
secdeva_severityLessThan("low", "critical").
secdeva_severityLessThan("medium", "high").
secdeva_severityLessThan("medium", "critical").
secdeva_severityLessThan("high", "critical").

transitionDenied(
    Issue,
    "Defer fix",
    @concatenate("Cannot defer fix, because severity is not ", DeferrableSeverityDisplayValue, " or lower.")
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "secdeva/fieldTypes/severity", Severity),
        secdeva_closestProject(Issue, Project),
        field(Project, "secdeva/fieldTypes/deferrableSeverity", DeferrableSeverity),
        field(("secdeva/fieldTypes/severity", DeferrableSeverity), "enumDisplayValue", DeferrableSeverityDisplayValue),
        secdeva_severityLessThan(DeferrableSeverity, Severity).

transitionDenied(
    Issue,
    "Accept risk",
    @concatenate("Cannot close as accepted, because severity is not ", AcceptableSeverityDisplayValue, " or lower." )
    ) :-
        field(Issue, "cardType", "secdeva/cardTypes/securityIssue"),
        field(Issue, "secdeva/fieldTypes/severity", Severity),
        secdeva_closestProject(Issue, Project),
        field(Project, "secdeva/fieldTypes/acceptableSeverity", AcceptableSeverity),
        field(("secdeva/fieldTypes/severity", AcceptableSeverity), "enumDisplayValue", AcceptableSeverityDisplayValue),
        secdeva_severityLessThan(AcceptableSeverity, Severity).
