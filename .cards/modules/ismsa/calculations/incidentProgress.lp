field(X, "base/fieldTypes/progress", ((50 * (OkTasks + NotRequiredTasks) + 20 * InProgressTasks)/ TotalTasks) + ((50 * Ok + 40 * PartlyOk + 20 * InProgress + 10 * Analysed) / Total)) :-
    field(X, "ismsa/fieldTypes/progress", "incident-progress"),
    Total = #count {
        card(Incident):
        field(Incident, "cardType", "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        not hiddenInTreeView(Incident)
    },
    Total > 0,
    Ok = #count {
        card(Incident):
        field(Incident, "cardType", "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Closed"),
        not hiddenInTreeView(Incident)
    },
    PartlyOk = #count {
        card(Incident):
        field(Incident, "cardType", "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response completed"),
        not hiddenInTreeView(Incident)
    },
    InProgress = #count {
        card(Incident):
        field(Incident, "cardType", "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response in progress"),
        not hiddenInTreeView(Incident)
    },
    Analysed = #count {
        card(Incident):
        field(Incident, "cardType", "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Analysed"),
        not hiddenInTreeView(Incident)
    },
    TotalTasks = #count {
        card(Task):
        field(Task, "cardType", "base/cardTypes/task"),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTasks > 0,
    OkTasks = #count {
        card(Task):
        field(Task, "cardType", "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as done")
    },
    InProgressTasks = #count {
        card(Task):
        field(Task, "cardType", "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "In progress")
    },
    NotRequiredTasks = #count {
        card(Task):
        field(Task, "cardType", "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Task)
    }.