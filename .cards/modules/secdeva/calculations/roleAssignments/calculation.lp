hiddenInTreeView(Assignment) :-
  base_projectCardType(Assignment, "base/cardTypes/roleAssignment"),
  field(Assignment, "workflowState", "Archived").