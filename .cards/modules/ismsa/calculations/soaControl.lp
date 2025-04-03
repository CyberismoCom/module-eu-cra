transitionDenied(Document, "Approve", "Fix policy failures before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    policyCheckFailure(Document, _, _, _).

transitionDenied(Document, "Approve", "Fix policy failures in at least one of the review subtask(s) before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    policyCheckFailure(ReviewTask, _, _, _) :
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

transitionDenied(Document, "Approve", "Fill in the owner field before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "base/fieldTypes/owner", _).

transitionDenied(Document, "Approve", "Fill in the approver field before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "base/fieldTypes/approver", _).

transitionDenied(Document, "Approve", "Fill in the information classification field before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "base/fieldTypes/informationClassification", _).

transitionDenied(Document, "Approve", "Fill in the approval date field before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "base/fieldTypes/approvalDate", _).

transitionDenied(Document, "Approve", "Complete the review task(s) before approving" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Document control", "Failing policy checks in all review tasks", "Fix policy failures in at least one of the review subtask(s)" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    field(Document, "workflowState", "Approved"),
    policyCheckFailure(ReviewTask, _, _, _) :
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    parent(ReviewTask, Document).

editingContentDenied(Document, "You cannot edit approved documents" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    field(Document, "workflowState", "Approved").

editingContentDenied(Document, "You cannot edit archived documents" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    field(Document, "workflowState", "Archived").

policyCheckFailure(Document, "Document control", "Scope statement is a required field", "Fill in the scope statement field." ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "ismsa/fieldTypes/soaScopeStatement", _).

policyCheckFailure(Document, "Document control", "Version is a required field", "Fill in the version field." ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "ismsa/fieldTypes/soaVersion", _).

policyCheckFailure(Document, "Document control", "Owner is a required field", "Fill in the owner field." ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/owner", _).

policyCheckFailure(Document, "Document control", "Approver is a required field", "Fill in the approver field." ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approver", _).

policyCheckFailure(Document, "Document control", "Approval date is a mandatory field", "Fill in the approval date field." ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    not field(Document, "workflowStateCategory", "initial"),
    not field(Document, "base/fieldTypes/approvalDate", _).

policyCheckFailure(Document, "Document control", "The review subtasks of approved documents must be closed", "Complete review task(s)" ):-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "workflowState", "Approved"),
    not field(ReviewTask, "workflowState", "Closed as done").

policyCheckFailure(Document, "Document control", "Reviewer cannot be the same as document owner", "The owner of a review task is also the owner of this document. Change the owner of the review task.") :-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(ReviewTask, "Document control", "Reviewer cannot be the same as document owner", "The owner of a review task is also the owner of this document. Change the owner of the review task.") :-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/owner", DocumentOwner),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentOwner = Reviewer.

policyCheckFailure(Document, "Document control", "Reviewer cannot be the same as document approver", "The owner of a review task is also the approver for this document. Change the owner of the review task or the approver of this document.") :-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/approver", DocumentApprover),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentApprover = Reviewer.

policyCheckFailure(ReviewTask, "Document control", "Reviewer cannot be the same as document approver", "The owner of this review task is also the approver of the document. Change the owner of this review task or the approver of the document.") :-
    field(Document, "cardType", "ismsa/cardTypes/statementOfApplicability"),
    parent(ReviewTask, Document),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    field(Document, "base/fieldTypes/approver", DocumentApprover),
    field(ReviewTask, "base/fieldTypes/owner", Reviewer),
    DocumentApprover = Reviewer.