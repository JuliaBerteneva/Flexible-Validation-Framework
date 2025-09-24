CLASS zvu_cl_export_validator DEFINITION INHERITING FROM zvu_cl_validator
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor,
      kunnr_check IMPORTING io_container TYPE REF TO zvu_cl_prop_container
                            is_error_message type zvu_s_message
                  EXPORTING ev_success   TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: gc_id TYPE zvu_validation_case_id VALUE 'EXPORT'.
ENDCLASS.



CLASS zvu_cl_export_validator IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_id = gc_id ).
  ENDMETHOD.

  METHOD kunnr_check.
    "some check on kunnr
    MESSAGE e003(zvu_validator) INTO DATA(lv_message).
  ENDMETHOD.

ENDCLASS.
