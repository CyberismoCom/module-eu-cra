hiddenInTreeView(Asset) :-
  ancestor(Asset, AssetRegister),
  field(AssetRegister, "base/fieldTypes/identifier", "secdeva_register_assets"),
  ismsa_asset(Asset).  