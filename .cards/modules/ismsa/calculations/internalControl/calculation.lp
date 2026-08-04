%
% Rules for calculating the Assessment and Assessment explanation
%

% Open

field(Control, "base/fieldTypes/assessment", "open") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

field(Control, "base/fieldTypes/assessmentExplanation", "The control has not been scoped yet") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

% Not applicable

field(Control, "base/fieldTypes/assessment", "notApplicable") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

field(Control, "base/fieldTypes/assessmentExplanation", "The control has been marked out of scope") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

% Not OK because of no evidence

ismsa_internalControlMissingEvidence(Control) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  not link(_, Control, "ismsa/linkTypes/evidences").

field(Control, "base/fieldTypes/assessment", "notOk") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  ismsa_internalControlMissingEvidence(Control).

field(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but required evidence has not been linked") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  ismsa_internalControlMissingEvidence(Control).

% Not OK because the internal control itself has failed policy checks

field(Control, "base/fieldTypes/assessment", "notOk") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control).

field(Control, "base/fieldTypes/assessmentExplanation", "The control has failed policy checks") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control).

% Not OK because there is evidence that has not been assessed as OK

field(Control, "base/fieldTypes/assessment", "notOk") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  not field(Evidence, "base/fieldTypes/assessment", "ok").

field(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but the linked evidence is not ready") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  not field(Evidence, "base/fieldTypes/assessment", "ok").

% Not OK because there is evidence and all evidence is ready, but there are policy check failures

field(Control, "base/fieldTypes/assessment", "notOk") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_policyCheckFailure(Evidence, _, _, _),
  field(Evidence2, "base/fieldTypes/assessment", "ok") :
  link(Evidence2, Control, "ismsa/linkTypes/evidences").

field(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but the linked evidence has failed policy checks") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_policyCheckFailure(Evidence, _, _, _),
  not field(Evidence2, "base/fieldTypes/assessment", "ok") :
  link(Evidence2, Control, "ismsa/linkTypes/evidences").

% OK because there is evidence and all linked evidence is ok

field(Control, "base/fieldTypes/assessment", "ok") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(_, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "base/fieldTypes/assessment", "ok"):
  link(Evidence, Control, "ismsa/linkTypes/evidences").

field(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope and there is valid evidence") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(_, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "base/fieldTypes/assessment", "ok") :
  link(Evidence, Control, "ismsa/linkTypes/evidences").

policyCheckSuccess(Control, "Internal control assessment", @concatenate("Control is acceptable: ", Explanation)) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "base/fieldTypes/assessment", "ok"),
  field(Control, "base/fieldTypes/assessmentExplanation", Explanation).

policyCheckSuccess(Control, "Internal control assessment", @concatenate("Control is acceptable: ", Explanation)) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "base/fieldTypes/assessment", "notApplicable"),
  field(Control, "base/fieldTypes/assessmentExplanation", Explanation).

%
% Justification is required if the control is out of scope
%

transitionDenied(
  Control,
  "Mark out of scope",
  "To mark this control as out of scope, you must first provide a justification. Fill in the scoping justification field."
) :-
    field(Control, "cardType", "ismsa/cardTypes/internalControl"),
    not field(Control, "base/fieldTypes/justification", _).

policyCheckFailure(
  Control,
  "Internal control",
  "Justification missing",
  "A scoping justification is mandatory for controls that have been marked out of scope. Set this field",
  "base/fieldTypes/justification"
) :-
    field(Control, "cardType", "ismsa/cardTypes/internalControl"),
    field(Control, "workflowState", "Out of scope"),
    not field(Control, "base/fieldTypes/justification", _).


%
% Policy check: All linked review evidence has expired
%


policyCheckFailure(
  Control,
  "Internal control",
  "All linked reviews have expired",
  "All linked review evidence for this control has expired. Complete a new review."
) :-
    field(Control, "cardType", "ismsa/cardTypes/internalControl"),
    field(Control, "workflowState", "In scope"),
    link(SomeReview, Control, "ismsa/linkTypes/evidences"),
    field(SomeReview, "cardType", "base/cardTypes/review"),
    field(SomeReview, "base/fieldTypes/lastReviewed", SomeLastReviewed),
    field(SomeReview, "base/fieldTypes/reviewPeriod", SomeReviewPeriod),
    @daysSince(SomeLastReviewed) > SomeReviewPeriod,
    @daysSince(LastReviewed) > ReviewPeriod :
    link(Review, Control, "ismsa/linkTypes/evidences"),
    field(Review, "cardType", "base/cardTypes/review"),
    field(Review, "base/fieldTypes/lastReviewed", LastReviewed),
    field(Review, "base/fieldTypes/reviewPeriod", ReviewPeriod).
