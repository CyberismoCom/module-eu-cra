hiddenInTreeView(Risk) :-
  ancestor(Risk, RiskRegister),
  field(RiskRegister, "base/fieldTypes/identifier", "secdeva_register_risks").  