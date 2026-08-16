% Identify whether the interface is external

secdeva_externalEntity(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/external").

secdeva_externalEntity(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/person").

secdeva_interfaceOrPhysicalConnection(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/interface").

field(Card, "secdeva/fieldTypes/isExternal", "yes") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    link(Source, Card, "secdeva/linkTypes/dataflow", _),
    secdeva_externalEntity(Source).

field(Card, "secdeva/fieldTypes/isExternal", "no") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    link(_, Card, "secdeva/linkTypes/dataflow", _),
    not secdeva_externalEntity(Source) :
    link(Source, Card, "secdeva/linkTypes/dataflow", _).

field(Card, "secdeva/fieldTypes/isExternal", "noInfo") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    not link(_, Card, "secdeva/linkTypes/dataflow", _).

% Identify whether dataflows to the interface cross a tryst boundary

field(Card, "secdeva/fieldTypes/crossesTrustBoundary", "noInfo") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    not link(_, Card, "secdeva/linkTypes/dataflow", _).

field(Card, "secdeva/fieldTypes/crossesTrustBoundary", "yes") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    link(Source, Card, "secdeva/linkTypes/dataflow", _),
    field(TrustBoundary, "cardType", "secdeva/cardTypes/trustBoundary"),
    ancestor(Card, TrustBoundary),
    not ancestor(Source, TrustBoundary).

field(Card, "secdeva/fieldTypes/crossesTrustBoundary", "no") :-
    secdeva_interfaceOrPhysicalConnection(Card),
    link(_, Card, "secdeva/linkTypes/dataflow", _),
    ancestor(Source, TrustBoundary) :
    link(Source, Card, "secdeva/linkTypes/dataflow", _),
    field(TrustBoundary, "cardType", "secdeva/cardTypes/trustBoundary"),
    ancestor(Card, TrustBoundary).

% Mandatory fields on adoption step 3

policyCheckFailure(Interface, "Interfaces", "Basic input validation testing is a required field", "Whether basic input validation testing is required has not been defined.", "secdeva/fieldTypes/basicInputValidationTestingRequired") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/basicInputValidationTestingRequired", _).

policyCheckFailure(Interface, "Interfaces", "Basic stress testing is a required field", "Whether basic stress testing is required has not been defined.","secdeva/fieldTypes/basicStressTestingRequired") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/basicStressTestingRequired", _).
  
policyCheckFailure(Interface, "Interfaces", "Fuzz testing is a required field", "Whether fuzz testing is required has not been defined.","secdeva/fieldTypes/fuzzTestingRequired") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/fuzzTestingRequired", _).

policyCheckFailure(Interface, "Interfaces", "Capacity testing is a required field", "Whether capacity testing is required has not been defined.","secdeva/fieldTypes/capacityTestingRequired") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/capacityTestingRequired", _).

policyCheckFailure(Interface, "Interfaces", "Network traffic load testing is a required field", "Whether network traffic load testing is required has not been defined.","secdeva/fieldTypes/networkTrafficLoadTestingRequired") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/networkTrafficLoadTestingRequired", _).

policyCheckFailure(Interface, "Interfaces", "Justification for security testing is a required field", "The justification for security testing has not been defined.","secdeva/fieldTypes/interfaceTestingScopingJustification") :-
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  secdeva_closestProject(Interface, Project),
  field(Project, "base/fieldTypes/adoptionStep", "step3"),
  not field(Interface, "secdeva/fieldTypes/interfaceTestingScopingJustification", _).

% Hide the interface review task in navigation unless on adoption step 3

hiddenInTreeView(ReviewTask) :-
  parent(ReviewTask, Interface),
  field(Interface, "cardType", "secdeva/cardTypes/interface"),
  field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
  secdeva_closestProject(Interface, Project),
  not field(Project, "base/fieldTypes/adoptionStep", "step3").
  
% Assessment

% Helper: true when an interface has an open review task with policy check failures
secdeva_interfaceReviewTaskPolicyFailure(Interface) :-
    parent(ReviewTask, Interface),
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    field(ReviewTask, "cardType", "base/cardTypes/reviewTask"),
    base_policyCheckFailure(ReviewTask, _, _, _).

% Assessment: "open" when the interface is in initial state or not yet approved without policy failures

field(Interface, "base/fieldTypes/assessment", "open") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    field(Interface, "workflowStateCategory", "initial").

field(Interface, "base/fieldTypes/assessmentExplanation", "The interface has not yet been approved") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    field(Interface, "workflowStateCategory", "initial").

field(Interface, "base/fieldTypes/assessment", "open") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    not field(Interface, "workflowState", "Approved"),
    not field(Interface, "workflowState", "Archived"),
    not base_policyCheckFailure(Interface, _, _, _),
    not secdeva_interfaceReviewTaskPolicyFailure(Interface).

field(Interface, "base/fieldTypes/assessmentExplanation", "The interface is being prepared or reviewed") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    not field(Interface, "workflowState", "Approved"),
    not field(Interface, "workflowState", "Archived"),
    not base_policyCheckFailure(Interface, _, _, _),
    not secdeva_interfaceReviewTaskPolicyFailure(Interface).

% Assessment: "notOk" when the interface has policy check failures

field(Interface, "base/fieldTypes/assessment", "notOk") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    base_policyCheckFailure(Interface, _, _, _).

field(Interface, "base/fieldTypes/assessmentExplanation", "The interface has policy check failures") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    base_policyCheckFailure(Interface, _, _, _).

field(Interface, "base/fieldTypes/assessment", "notOk") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    not field(Interface, "workflowState", "Approved"),
    not field(Interface, "workflowState", "Archived"),
    not base_policyCheckFailure(Interface, _, _, _),
    secdeva_interfaceReviewTaskPolicyFailure(Interface).

field(Interface, "base/fieldTypes/assessmentExplanation", "One or more review tasks have policy check failures") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not field(Interface, "workflowStateCategory", "initial"),
    not field(Interface, "workflowState", "Approved"),
    not field(Interface, "workflowState", "Archived"),
    not base_policyCheckFailure(Interface, _, _, _),
    secdeva_interfaceReviewTaskPolicyFailure(Interface).

% Assessment: "ok" when the interface is approved and has no policy check failures

field(Interface, "base/fieldTypes/assessment", "ok") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    field(Interface, "workflowState", "Approved"),
    not base_policyCheckFailure(Interface, _, _, _).

field(Interface, "base/fieldTypes/assessmentExplanation", "The interface is approved and has no policy check failures") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    field(Interface, "workflowState", "Approved"),
    not base_policyCheckFailure(Interface, _, _, _).
