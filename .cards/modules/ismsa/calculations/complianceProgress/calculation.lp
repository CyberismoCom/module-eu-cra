field(X, "base/fieldTypes/progress", (100 * (Ok + NotRequired) + 95 * ToBeVerified + 50 * Adopting + 25 * Planned ) / Total) :-
    field(X, "ismsa/fieldTypes/progress", "compliance-progress"),
    Total = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        not hiddenInTreeView(Requirement)
    },
    Total > 0,
    Ok = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        field(Requirement, "workflowState", "Closed as compliant"),
        not hiddenInTreeView(Requirement)
    },
    Planned = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        field(Requirement, "workflowState", "Planned"),
        not hiddenInTreeView(Requirement)
    },
    Adopting = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        field(Requirement, "workflowState", "Adopting"),
        not hiddenInTreeView(Requirement)
    },
    ToBeVerified = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        field(Requirement, "workflowState", "To be verified"),
        not hiddenInTreeView(Requirement)
    },
    NotRequired = #count {
        card(Requirement):
        field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
        ancestor(Requirement, X),
        field(Requirement, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Requirement)
    }.