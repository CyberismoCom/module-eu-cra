% Helper: true when a document has an open review task with policy check failures
ismsa_reviewTaskPolicyFailure(Document) :-
    parent(ReviewTask, Document),
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    base_policyCheckFailure(ReviewTask, _, _, _).

% Assessment: "open" when the document is in initial state or not yet approved without policy failures

field(Document, "base/fieldTypes/assessment", "open") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    field(Document, "workflowStateCategory", "initial").

field(Document, "base/fieldTypes/assessmentExplanation", "The document has not yet been submitted for approval") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    field(Document, "workflowStateCategory", "initial").

field(Document, "base/fieldTypes/assessment", "open") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "workflowState", "Approved"),
    not field(Document, "workflowState", "Archived"),
    not base_policyCheckFailure(Document, _, _, _),
    not ismsa_reviewTaskPolicyFailure(Document).

field(Document, "base/fieldTypes/assessmentExplanation", "The document is being prepared or reviewed") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "workflowState", "Approved"),
    not field(Document, "workflowState", "Archived"),
    not base_policyCheckFailure(Document, _, _, _),
    not ismsa_reviewTaskPolicyFailure(Document).

% Assessment: "notOk" when the document has policy check failures

field(Document, "base/fieldTypes/assessment", "notOk") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    base_policyCheckFailure(Document, _, _, _).

field(Document, "base/fieldTypes/assessmentExplanation", "The document has policy check failures") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    base_policyCheckFailure(Document, _, _, _).

field(Document, "base/fieldTypes/assessment", "notOk") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "workflowState", "Approved"),
    not field(Document, "workflowState", "Archived"),
    not base_policyCheckFailure(Document, _, _, _),
    ismsa_reviewTaskPolicyFailure(Document).

field(Document, "base/fieldTypes/assessmentExplanation", "One or more review tasks have policy check failures") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "workflowState", "Approved"),
    not field(Document, "workflowState", "Archived"),
    not base_policyCheckFailure(Document, _, _, _),
    ismsa_reviewTaskPolicyFailure(Document).

% Assessment: "ok" when the document is approved and has no policy check failures

field(Document, "base/fieldTypes/assessment", "ok") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    field(Document, "workflowState", "Approved"),
    not base_policyCheckFailure(Document, _, _, _).

field(Document, "base/fieldTypes/assessmentExplanation", "The document is approved and has no policy check failures") :-
    field(Document, "cardType", "base/cardTypes/controlledDocument"),
    field(Document, "workflowState", "Approved"),
    not base_policyCheckFailure(Document, _, _, _).