field(X, "base/fieldTypes/progress", (100 * (ClosedAsAccepted + ClosedAsTransferred + ClosedAsNotApplicable + ClosedAsAvoided) + 95 * (TreatmentComplete + NeedsMonitoring) + 60 * TreatmentInProgress + 40 * TreatmentPlanned + 20 * Analysed )/ (Total-ClosedAsDuplicate)) :-
    field(X, "ismsa/fieldTypes/progress", "risk-progress"),
    Total = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        not hiddenInTreeView(Risk)
    },
    Total > 0,
    Analysed = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        field(Risk, "workflowState", "Analysed"),
        not hiddenInTreeView(Risk)
    },
    TreatmentPlanned = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        field(Risk, "workflowState", "Treatment planned"),
        not hiddenInTreeView(Risk)
    },
    TreatmentInProgress = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        field(Risk, "workflowState", "Treatment in progress"),
        not hiddenInTreeView(Risk)
    },
    TreatmentComplete = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        field(Risk, "workflowState", "Treatment complete"),
        not hiddenInTreeView(Risk)
    },
    NeedsMonitoring = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        field(Risk, "workflowState", "Needs monitoring"),
        not hiddenInTreeView(Risk)
    },
    ClosedAsDuplicate = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(RRisk, X),
        field(Risk, "workflowState", "Closed as duplicate"),
        not hiddenInTreeView(Risk)
    },
    ClosedAsAccepted = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(RRisk, X),
        field(Risk, "workflowState", "Closed as accepted"),
        not hiddenInTreeView(Risk)
    },
    ClosedAsTransferred = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(RRisk, X),
        field(Risk, "workflowState", "Closed as transferred"),
        not hiddenInTreeView(Risk)
    },
    ClosedAsNotApplicable = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(RRisk, X),
        field(Risk, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Risk)
    },
    ClosedAsAvoided = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(RRisk, X),
        field(Risk, "workflowState", "Closed as avoided"),
        not hiddenInTreeView(Risk)
    }.

field(X, "base/fieldTypes/progress", 0) :-
    field(X, "ismsa/fieldTypes/progress", "risk-progress"),
    Total = #count {
        card(Risk):
        field(Risk, "cardType", "ismsa/cardTypes/risk"),
        ancestor(Risk, X),
        not hiddenInTreeView(Risk)
    },
    Total = 0.