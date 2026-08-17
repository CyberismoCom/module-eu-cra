% Assessment: "open" when the review is in initial state

field(Review, "base/fieldTypes/assessment", "open") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Draft").

field(Review, "base/fieldTypes/assessmentExplanation", "The review has not yet been conducted") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Draft").

% Assessment: "notOk" when the review has policy check failures

field(Review, "base/fieldTypes/assessment", "notOk") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Passed"),
    base_policyCheckFailure(Review, _, _, _).

field(Review, "base/fieldTypes/assessmentExplanation", "The review has policy check failures") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Passed"),
    base_policyCheckFailure(Review, _, _, _).

% Assessment: "notOk" when the review has failed

field(Review, "base/fieldTypes/assessment", "notOk") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Failed").

field(Review, "base/fieldTypes/assessmentExplanation", "The review has failed") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Failed").

% Assessment: "ok" when the review is passed and has no policy check failures

field(Review, "base/fieldTypes/assessment", "ok") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Passed"),
    not base_policyCheckFailure(Review, _, _, _).

field(Review, "base/fieldTypes/assessmentExplanation", "The review is passed and has no policy check failures") :-
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "workflowState", "Passed"),
    not base_policyCheckFailure(Review, _, _, _).