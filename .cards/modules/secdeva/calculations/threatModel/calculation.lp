% Threat model components are assets that may be affected by security issues

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/process").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/dataStore").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/person").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/trustBoundary").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/external").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/interface").

link(Asset, SecurityIssue, "ismsa/linkTypes/presentsRisk") :-
    parent(SecurityIssue, Asset),
    field(SecurityIssue, "cardType", "secdeva/cardTypes/securityIssue"),
    secdeva_threatModelComponent(Asset).

% Defining ismsa_asset for threat model components makes them work correctly in assets-risks-controls diagrams

ismsa_asset(Card, "Process") :-
    field(Card, "cardType", "secdeva/cardTypes/process").

ismsa_asset(Card, "Data store") :-
    field(Card, "cardType", "secdeva/cardTypes/dataStore").

ismsa_asset(Card, "Person") :-
    field(Card, "cardType", "secdeva/cardTypes/person").

ismsa_asset(Card, "Trust boundary") :-
    field(Card, "cardType", "secdeva/cardTypes/trustBoundary").

ismsa_asset(Card, "External entity") :-
    field(Card, "cardType", "secdeva/cardTypes/external").

ismsa_asset(Card, "Interface") :-
    field(Card, "cardType", "secdeva/cardTypes/interface").

% Disable ISMS essentials asset control for threat model elements

ismsa_disableAssetControl(Card) :- secdeva_threatModelComponent(Card).

% Threat model is similar to a controlled document, but it is a separate card type,
% so we need to include similar rules for it as there are for controlled documents in the base module:

transitionDenied(Document, "Approve", "Fix policy failures before approving") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    policyCheckFailure(Document, _, _, _).

transitionDenied(Document, "Approve", "Fix policy failures in at least one of the review subtask(s) before approving" ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    policyCheckFailure(ReviewTask, _, _, _) :
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

transitionDenied(Document, "Approve", "Fill in the owner field before approving") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "base/fieldTypes/owner", _).

transitionDenied(Document, "Approve", "Fill in the approver field before approving") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "base/fieldTypes/approver", _).

transitionDenied(Document, "Approve", "Fill in the information classification field before approving") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "base/fieldTypes/informationClassification", _).

onTransitionSetField(Document, "Approve", Document, "base/fieldTypes/approvalDate", @today) :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel").

transitionDenied(Document, "Approve", "Complete the review task(s) before approving") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Document control", "Failing policy checks in all review tasks", "Fix policy failures in at least one of the review subtask(s)" ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    field(Document, "workflowState", "Approved"),
    policyCheckFailure(ReviewTask, _, _, _) :
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

editingContentDenied(Document, "You cannot edit approved threat models" ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    field(Document, "workflowState", "Approved").

editingContentDenied(Document, "You cannot edit archived threat models" ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    field(Document, "workflowState", "Archived").

policyCheckFailure(Document, "Threat model control", "Owner is a required field", "Fill in the owner field." ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/owner", _).

policyCheckFailure(Document, "Threat model control", "Approver is a required field", "Fill in the approver field." ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approver", _).

policyCheckFailure(Document, "Threat model control", "Approval date is a mandatory field", "Fill in the approval date field." ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approvalDate", _).

policyCheckFailure(Document, "Threat model control", "The review subtasks of approved documents must be closed", "Complete review task(s)" ):-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "workflowState", "Approved"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Threat model control", "Reviewer cannot be the same as document owner", "The owner of a review task is also the owner of this threat model. Change the owner of the review task.") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(ReviewTask, "Threat model control", "Reviewer cannot be the same as threat model owner", "The owner of a review task is also the owner of this threat model. Change the owner of the review task.") :-
    field(Document, "cardType", "secdeva/cardTypes/threatModel"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(Document, "Document control", "Review has expired", "Complete a new review of this document.") :-
    field(Document, "cardType", "base/cardTypes/threatModel"),
    field(Document, "workflowState", "Approved"),
    field(Document, "base/fieldTypes/reviewPeriod", ReviewPeriod),
    @daysSince(LastReviewed) > ReviewPeriod :
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(ReviewTask, "workflowState", "Closed as done"),
    field(ReviewTask, "base/fieldTypes/lastReviewed", LastReviewed).

% Individual attack vector cards are not shown in the navigation

hiddenInTreeView(AttackVector) :-
    field(AttackVector, "base/fieldTypes/identifier", "secdeva_attack-vector").


%
% Threat model assessment
%

% Helper: true when a threat model has an open review task with policy check failures
ismsa_reviewTaskPolicyFailure(ThreatModel) :-
    parent(ReviewTask, ThreatModel),
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    base_policyCheckFailure(ReviewTask, _, _, _).

% Assessment: "open" when the threat model is in initial state or not yet approved without policy failures

field(ThreatModel, "base/fieldTypes/assessment", "open") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    field(ThreatModel, "workflowStateCategory", "initial").

field(ThreatModel, "base/fieldTypes/assessmentExplanation", "The threat model has not yet been submitted for approval") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    field(ThreatModel, "workflowStateCategory", "initial").

field(ThreatModel, "base/fieldTypes/assessment", "open") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    not field(ThreatModel, "workflowState", "Approved"),
    not field(ThreatModel, "workflowState", "Archived"),
    not base_policyCheckFailure(ThreatModel, _, _, _),
    not ismsa_reviewTaskPolicyFailure(ThreatModel).

field(ThreatModel, "base/fieldTypes/assessmentExplanation", "The threat model is being prepared or reviewed") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    not field(ThreatModel, "workflowState", "Approved"),
    not field(ThreatModel, "workflowState", "Archived"),
    not base_policyCheckFailure(ThreatModel, _, _, _),
    not ismsa_reviewTaskPolicyFailure(ThreatModel).

% Assessment: "notOk" when the document has policy check failures

field(ThreatModel, "base/fieldTypes/assessment", "notOk") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    base_policyCheckFailure(ThreatModel, _, _, _).

field(ThreatModel, "base/fieldTypes/assessmentExplanation", "The threat model has policy check failures") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    base_policyCheckFailure(ThreatModel, _, _, _).

field(ThreatModel, "base/fieldTypes/assessment", "notOk") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    not field(ThreatModel, "workflowState", "Approved"),
    not field(ThreatModel, "workflowState", "Archived"),
    not base_policyCheckFailure(ThreatModel, _, _, _),
    ismsa_reviewTaskPolicyFailure(ThreatModel).

field(ThreatModel, "base/fieldTypes/assessmentExplanation", "One or more review tasks have policy check failures") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    not field(ThreatModel, "workflowStateCategory", "initial"),
    not field(ThreatModel, "workflowState", "Approved"),
    not field(ThreatModel, "workflowState", "Archived"),
    not base_policyCheckFailure(ThreatModel, _, _, _),
    ismsa_reviewTaskPolicyFailure(ThreatModel).

% Assessment: "ok" when the document is approved and has no policy check failures

field(ThreatModel, "base/fieldTypes/assessment", "ok") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    field(ThreatModel, "workflowState", "Approved"),
    not base_policyCheckFailure(ThreatModel, _, _, _).

field(ThreatModel, "base/fieldTypes/assessmentExplanation", "The threat model is approved and has no policy check failures") :-
    field(ThreatModel, "cardType", "secdeva/cardTypes/threatModel"),
    field(ThreatModel, "workflowState", "Approved"),
    not base_policyCheckFailure(ThreatModel, _, _, _).