field(X, "base/fieldTypes/progress", ((50 * (OkTasks + NotRequiredTasks) + 20 * InProgressTasks)/ TotalTasks) + ((50 * Ok + 40 * PartlyOk + 20 * InProgress + 10 * Analysed) / Total)) :-
    field(X, "ismsa/fieldTypes/progress", "incident-progress"),
    Total = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        not hiddenInTreeView(Incident)
    },
    Total > 0,
    Ok = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Closed"),
        not hiddenInTreeView(Incident)
    },
    PartlyOk = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response completed"),
        not hiddenInTreeView(Incident)
    },
    InProgress = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response in progress"),
        not hiddenInTreeView(Incident)
    },
    Analysed = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Analysed"),
        not hiddenInTreeView(Incident)
    },
    TotalTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTasks > 0,
    OkTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as done"),
        not hiddenInTreeView(Task)
    },
    InProgressTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "In progress"),
        not hiddenInTreeView(Task)
    },
    NotRequiredTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Task)
    },
    TotalNearMiss = #count {
        card(NearMiss):
        base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
        ancestor(NearMiss, X),
        not hiddenInTreeView(NearMiss)
    },
    TotalNearMiss = 0.

field(X, "base/fieldTypes/progress", ((40 * (OkTasks + NotRequiredTasks) + 16 * InProgressTasks)/ TotalTasks) + ((40 * Ok + 32 * PartlyOk + 16 * InProgress + 8 * Analysed) / Total) + ((20 * OkNearMiss) / TotalNearMiss)) :-
    field(X, "ismsa/fieldTypes/progress", "incident-progress"),
    Total = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        not hiddenInTreeView(Incident)
    },
    Total > 0,
    Ok = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Closed"),
        not hiddenInTreeView(Incident)
    },
    PartlyOk = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response completed"),
        not hiddenInTreeView(Incident)
    },
    InProgress = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Response in progress"),
        not hiddenInTreeView(Incident)
    },
    Analysed = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        field(Incident, "workflowState", "Analysed"),
        not hiddenInTreeView(Incident)
    },
    TotalTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTasks > 0,
    OkTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as done"),
        not hiddenInTreeView(Task)
    },
    InProgressTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "In progress"),
        not hiddenInTreeView(Task)
    },
    NotRequiredTasks = #count {
        card(Task):
        base_projectCardType(Task, "base/cardTypes/task"),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Task)
    },
    TotalNearMiss = #count {
        card(NearMiss):
        base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
        ancestor(NearMiss, X),
        not hiddenInTreeView(NearMiss)
    },
    TotalNearMiss > 0,
    OkNearMiss = #count {
        card(NearMiss):
        base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
        ancestor(NearMiss, X),
        field(NearMiss, "workflowState", "Closed"),
        not hiddenInTreeView(NearMiss)
    }.

field(X, "base/fieldTypes/progress", ((100 * OkNearMiss) / TotalNearMiss)) :-
    field(X, "ismsa/fieldTypes/progress", "incident-progress"),
    Total = #count {
        card(Incident):
        base_projectCardType(Incident, "ismsa/cardTypes/incident"),
        ancestor(Incident, X),
        not hiddenInTreeView(Incident)
    },
    Total = 0,
    TotalNearMiss = #count {
        card(NearMiss):
        base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
        ancestor(NearMiss, X),
        not hiddenInTreeView(NearMiss)
    },
    TotalNearMiss > 0,
    OkNearMiss = #count {
        card(NearMiss):
        base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
        ancestor(NearMiss, X),
        field(NearMiss, "workflowState", "Closed"),
        not hiddenInTreeView(NearMiss)
    }.

 field(X, "base/fieldTypes/progress", 0) :-
     field(X, "ismsa/fieldTypes/progress", "incident-progress"),
     Total = #count {
         card(Incident):
         base_projectCardType(Incident, "ismsa/cardTypes/incident"),
         ancestor(Incident, X),
         not hiddenInTreeView(Incident)
     },
     Total = 0,
     TotalNearMiss = #count {
         card(NearMiss):
         base_projectCardType(NearMiss, "ismsa/cardTypes/nearMiss"),
         ancestor(NearMiss, X),
         not hiddenInTreeView(NearMiss)
     },
     TotalNearMiss = 0.