% Extension modules can define installable extensions to cards with following kinds of facts:

% This is the legacy format, for secdeva/cardTypes/project:
%
% secdeva_installableExtension(
%     ExtensibleCardIdentifier,   % identifier of the card that can be extended
%     ModuleDescription,          % display name of the module that introduces an extension
%     Template,                   % the template that includes the extensions
%     ButtonLabel,                % button label for instantiating the extensions
%     ExampleIdentifier           % an example of an identifier of an extension, for checking whether the extension has been installed
% ).

% This is the new format, for secdeva/cardTypes/project2. 
% The checking is done based on the templateCard fields
%
% secdeva_installableExtension(
%     ExtensibleCardIdentifier,   % identifier of the card that can be extended
%     ModuleDescription,          % display name of the module that introduces an extension
%     Template,                   % the template that includes the extensions
%     ButtonLabel                 % button label for instantiating the extensions
% ).
