ismsa_task(Task) :-
    base_projectCardType(Task, "base/cardTypes/task").

ismsa_task(Task) :-
    base_projectCardType(Task, "base/cardTypes/recurringTask").

field(X, "base/fieldTypes/progress", ((100 * (Ok + NotRequired) + 20 * InProgress) + (100 * OkTargets + 20 * InProgressTargets)) / (TotalTasks + TotalTargets)) :-
    field(X, "ismsa/fieldTypes/progress", "task-progress"),
    TotalTasks = #count {
        card(Task):
        ismsa_task(Task),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTargets = #count {
        card(Target):
        base_projectCardType(Target, "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        not hiddenInTreeView(Target)
    },
    TotalTasks + TotalTargets > 0,
    Ok = #count {
        card(Task):
        ismsa_task(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as done"),
        not hiddenInTreeView(Task)
    },
    InProgress = #count {
        card(Task):
        ismsa_task(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "In progress"),
        not hiddenInTreeView(Task)
    },
    NotRequired = #count {
        card(Task):
        ismsa_task(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Task)
    },
    OkTargets = #count {
        card(Target):
        base_projectCardType(Target, "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        field(Target, "workflowState", "Closed as done"),
        not hiddenInTreeView(Target)
    },
    InProgressTargets = #count {
        card(Target):
        base_projectCardType(Target, "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        field(Target, "workflowState", "Executing"),
        not hiddenInTreeView(Target)
    }.

field(X, "base/fieldTypes/progress", 0) :-
    field(X, "ismsa/fieldTypes/progress", "task-progress"),
    TotalTasks = #count {
        card(Task):
        ismsa_task(Task),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTargets = #count {
        card(Target):
        base_projectCardType(Target, "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        not hiddenInTreeView(Target)
    },
    TotalTasks + TotalTargets = 0.