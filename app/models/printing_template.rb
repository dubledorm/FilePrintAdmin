class PrintingTemplate
  include Mongoid::Document

  store_in collection: 'PrintingTemplates'
  field 'ApplicationType',as: :application_type, type: Integer
  field 'Name', as: :name, type: String
  field 'FileContent', as: :file_content, type: BSON::Binary
  field 'PrinterType', as: :printer_type, type: Integer
end
