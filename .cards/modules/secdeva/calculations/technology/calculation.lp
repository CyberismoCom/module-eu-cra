% A technology assessment is similar to a controlled document, but it is a separate card type,
% so we need to include similar rules for it as there are for controlled documents in the base module:

transitionDenied(Document, "Approve", "Fix policy failures before approving") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    policyCheckFailure(Document, _, _, _).

transitionDenied(Document, "Approve", "Fix policy failures in at least one of the review subtask(s) before approving" ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    policyCheckFailure(ReviewTask, _, _, _) :
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

transitionDenied(Document, "Approve", "Fill in the owner field before approving") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "base/fieldTypes/owner", _).

transitionDenied(Document, "Approve", "Fill in the approver field before approving") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "base/fieldTypes/approver", _).

transitionDenied(Document, "Approve", "Fill in the information classification field before approving") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "base/fieldTypes/informationClassification", _).

onTransitionSetField(Document, "Approve", Document, "base/fieldTypes/approvalDate", @today) :-
    base_projectCardType(Document, "secdeva/cardTypes/technology").

transitionDenied(Document, "Approve", "Complete the review task(s) before approving") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    parent(ReviewTask, Document),
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Document control", "Failing policy checks in all review tasks", "Fix policy failures in at least one of the review subtask(s)" ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    field(Document, "workflowState", "Approved"),
    policyCheckFailure(ReviewTask, _, _, _) :
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

editingContentDenied(Document, "You cannot edit approved technology assessments" ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    field(Document, "workflowState", "Approved").

editingContentDenied(Document, "You cannot edit archived technology assessments" ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    field(Document, "workflowState", "Archived").

policyCheckFailure(Document, "Threat model control", "Owner is a required field", "Fill in the owner field." ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/owner", _).

policyCheckFailure(Document, "Threat model control", "Approver is a required field", "Fill in the approver field." ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approver", _).

policyCheckFailure(Document, "Threat model control", "Approval date is a mandatory field", "Fill in the approval date field." ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approvalDate", _).

policyCheckFailure(Document, "Threat model control", "The review subtasks of approved documents must be closed", "Complete review task(s)" ):-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    parent(ReviewTask, Document),
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    field(Document, "workflowState", "Approved"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Threat model control", "Reviewer cannot be the same as document owner", "The owner of a review task is also the owner of this threat model. Change the owner of the review task.") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    parent(ReviewTask, Document),
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(ReviewTask, "Threat model control", "Reviewer cannot be the same as threat model owner", "The owner of a review task is also the owner of this threat model. Change the owner of the review task.") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    parent(ReviewTask, Document),
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(Document, "Document control", "Review has expired", "Complete a new review of this document.") :-
    base_projectCardType(Document, "secdeva/cardTypes/technology"),
    field(Document, "workflowState", "Approved"),
    field(Document, "base/fieldTypes/reviewPeriod", ReviewPeriod),
    @daysSince(LastReviewed) > ReviewPeriod :
    parent(ReviewTask, Document),
    base_projectCardType(ReviewTask, "base/cardTypes/reviewTask"),
    field(ReviewTask, "workflowState", "Closed as done"),
    field(ReviewTask, "base/fieldTypes/lastReviewed", LastReviewed).
