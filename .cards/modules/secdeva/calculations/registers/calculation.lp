
% secdeva_register(Register) means that Register is a register in a development project
secdeva_register(Register) :- base_projectCardType(Register, "secdeva/cardTypes/register").
secdeva_register(Register) :- base_projectCardType(Register, "secdeva/cardTypes/riskRegister").
secdeva_register(Register) :- base_projectCardType(Register, "secdeva/cardTypes/securityIssueRegister").
secdeva_register(Register) :- base_projectCardType(Register, "secdeva/cardTypes/periodicReviewRegister").


% secdeva_registerMember(Item, Register) means that Item belongs to the register Register

% members of the asset register

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_assets"),
  secdeva_closestProject(Asset, Project),
  ismsa_asset(Asset).

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_assets"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "secdeva/cardTypes/dataStore").

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_assets"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "secdeva/cardTypes/process").

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_assets"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "secdeva/cardTypes/interface").

% members of the solution structure register

secdeva_registerMember(Product, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_solution-structure"),
  secdeva_closestProject(Product, Project),
  base_projectCardType(Product, "secdeva/cardTypes/product").

% members of the own and third-party product groups
%
% These are grouping cards inside the solution structure register. Membership follows
% the origin of the product rather than the position of the card, so a product filed
% under the wrong group still counts towards the right one.

secdeva_registerMember(Product, Group) :-
  secdeva_closestProject(Group, Project),
  field(Group, "base/fieldTypes/identifier", GroupIdentifier),
  secdeva_closestProject(Product, Project),
  secdeva_productGroup(Product, GroupIdentifier).

% members of the risk register

secdeva_registerMember(Risk, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_risks"),
  secdeva_closestProject(Risk, Project),
  base_projectCardType(Risk, "ismsa/cardTypes/risk").

% members of the security requirement register

secdeva_registerMember(Requirement, Register) :-
  ancestor(Requirement, Register),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_security-requirements"),
  base_projectCardType(Requirement, "secdeva/cardTypes/requirement").

secdeva_registerMember(Requirement, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_security-requirements"),
  secdeva_closestProject(Requirement, Project),
  base_projectCardType(Requirement, "secdeva/cardTypes/requirement").

% members of the technology assessments register

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_technology-assessments"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "secdeva/cardTypes/technology").

% members of the security issue register

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_security-issues"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "secdeva/cardTypes/securityIssue").

% members of the decision register

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_decisions"),
  secdeva_closestProject(Asset, Project),
  base_projectCardType(Asset, "base/cardTypes/decision").

% members of the periodic review register

secdeva_registerMember(Asset, Register) :-
  secdeva_closestProject(Register, Project),
  field(Register, "base/fieldTypes/identifier", "secdeva_register_periodic-reviews"),
  secdeva_closestProject(Asset, Project),
  field(Asset, "base/fieldTypes/identifier", "secdeva_review_periodic").

%
% Assessment
%

% An empty register has "open" assessment

field(Register, "base/fieldTypes/assessment", "open" ):-
  secdeva_register(Register),
  not secdeva_registerMember(_, Register).
    
field(Register, "base/fieldTypes/assessmentExplanation", "The register does not contain any items" ):-
  secdeva_register(Register),
  not secdeva_registerMember(_, Register).

% The assessment of a register is Not OK, if there are items with policy check failures

field(Register, "base/fieldTypes/assessment", "notOk" ):-
  secdeva_register(Register),
  secdeva_registerMember(Item, Register),
  base_policyCheckFailure(Item, _, _, _).

field(Register, "base/fieldTypes/assessmentExplanation", "There are policy check failures in the items of this register. Fix the policy check failures." ):-
  secdeva_register(Register),
  secdeva_registerMember(Item, Register),
  base_policyCheckFailure(Item, _, _, _).

% If all the items have no failures, then the assessment of the register is OK

field(Register, "base/fieldTypes/assessment", "ok" ):-
  secdeva_register(Register),
  secdeva_registerMember(_, Register),
  not base_policyCheckFailure(Item, _, _, _) :
  secdeva_registerMember(Item, Register).

field(Register, "base/fieldTypes/assessmentExplanation", "The register contains items and there are no policy check failures." ):-
  secdeva_register(Register),
  secdeva_registerMember(_, Register),
  not base_policyCheckFailure(Item, _, _, _) :
  secdeva_registerMember(Item, Register).
