%
% Rules for calculating the Assessment and Assessment explanation
%

% Open

fieldCalculated(Control, "base/fieldTypes/assessment", "open") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control has not been scoped yet") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

% Not applicable

fieldCalculated(Control, "base/fieldTypes/assessment", "notApplicable") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control has been marked out of scope") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

% Not OK because of no evidence

ismsa_internalControlMissingEvidence(Control) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  not link(_, Control, "ismsa/linkTypes/evidences").

ismsa_internalControlEvidenceFailure(Control) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_policyCheckFailure(Evidence, _, _, _).

fieldCalculated(Control, "base/fieldTypes/assessment", "notOk") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  ismsa_internalControlMissingEvidence(Control).

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but required evidence has not been linked") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  ismsa_internalControlMissingEvidence(Control).

% Not OK because the internal control itself has failed policy checks

fieldCalculated(Control, "base/fieldTypes/assessment", "notOk") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control).

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control has failed policy checks") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control).

% Not OK because there is evidence that has not been assessed as OK

fieldCalculated(Control, "base/fieldTypes/assessment", "notOk") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  not field(Evidence, "base/fieldTypes/assessment", "ok").

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but the linked evidence is not ready") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  not field(Evidence, "base/fieldTypes/assessment", "ok").

% Not OK because there is evidence and all evidence is ready, but there are policy check failures

fieldCalculated(Control, "base/fieldTypes/assessment", "notOk") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_policyCheckFailure(Evidence, _, _, _),
  field(Evidence2, "base/fieldTypes/assessment", "ok") :
  link(Evidence2, Control, "ismsa/linkTypes/evidences").

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope but the linked evidence has failed policy checks") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_policyCheckFailure(Evidence, _, _, _),
  field(Evidence2, "base/fieldTypes/assessment", "ok") :
  link(Evidence2, Control, "ismsa/linkTypes/evidences").

% OK because there is evidence and all linked evidence is ok

fieldCalculated(Control, "base/fieldTypes/assessment", "ok") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  not ismsa_internalControlEvidenceFailure(Control),
  link(_, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "base/fieldTypes/assessment", "ok"):
  link(Evidence, Control, "ismsa/linkTypes/evidences").

fieldCalculated(Control, "base/fieldTypes/assessmentExplanation", "The control is in scope and there is valid evidence") :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "In scope"),
  not base_policyCheckFailure(Control, _, _, _),
  not ismsa_internalControlMissingEvidence(Control),
  not ismsa_internalControlEvidenceFailure(Control),
  link(_, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "base/fieldTypes/assessment", "ok") :
  link(Evidence, Control, "ismsa/linkTypes/evidences").

policyCheckSuccess(Control, "Internal control assessment", @concatenate("Control is acceptable: ", Explanation)) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "base/fieldTypes/assessment", "ok"),
  field(Control, "base/fieldTypes/assessmentExplanation", Explanation).

policyCheckSuccess(Control, "Internal control assessment", @concatenate("Control is acceptable: ", Explanation)) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
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
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    not field(Control, "base/fieldTypes/justification", _).

policyCheckFailure(
  Control,
  "Internal control",
  "Justification missing",
  "A scoping justification is mandatory for controls that have been marked out of scope. Set this field",
  "base/fieldTypes/justification"
) :-
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "workflowState", "Out of scope"),
    not field(Control, "base/fieldTypes/justification", _).

%
% Policy check: Assessment has been overridden but the explanation has not been updated
%

policyCheckFailure(
  Control,
  "Internal control",
  "Assessment explanation not given for overridden assessment",
  "The assessment field has been overridden, but the assessment explanation has not been updated. Explain the assessment by overriding the assessment explanation field.",
  "base/fieldTypes/assessmentExplanation"
) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  fieldOverride(Control, "base/fieldTypes/assessment", _),
  not fieldOverride(Control, "base/fieldTypes/assessmentExplanation", _).

%
% Policy check: All linked review evidence has expired
%

policyCheckFailure(
  Control,
  "Internal control",
  "All linked reviews have expired",
  "All linked review evidence for this control has expired. Complete a new review."
) :-
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "workflowState", "In scope"),
    link(SomeReview, Control, "ismsa/linkTypes/evidences"),
    base_projectCardType(SomeReview, "base/cardTypes/review"),
    field(SomeReview, "base/fieldTypes/lastReviewed", SomeLastReviewed),
    field(SomeReview, "base/fieldTypes/reviewPeriod", SomeReviewPeriod),
    @daysSince(SomeLastReviewed) > SomeReviewPeriod,
    @daysSince(LastReviewed) > ReviewPeriod :
    link(Review, Control, "ismsa/linkTypes/evidences"),
    base_projectCardType(Review, "base/cardTypes/review"),
    field(Review, "base/fieldTypes/lastReviewed", LastReviewed),
    field(Review, "base/fieldTypes/reviewPeriod", ReviewPeriod).
