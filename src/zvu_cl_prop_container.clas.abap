CLASS zvu_cl_prop_container DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: mt_container TYPE zvu_tt_container_structure.
    METHODS: set_parameter IMPORTING iv_name  TYPE zvu_parameter_name
                                     iv_value TYPE REF TO data,
      set_table IMPORTING it_data TYPE zvu_tt_container_structure,
      get_parameter IMPORTING iv_name         TYPE zvu_parameter_name
                    RETURNING VALUE(rv_value) TYPE REF TO data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvu_cl_prop_container IMPLEMENTATION.
  METHOD set_parameter.
    INSERT VALUE #( name = iv_name value = iv_value ) INTO TABLE mt_container.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e001(zvu_validator) INTO DATA(lv_message).
    ENDIF.
  ENDMETHOD.
  METHOD set_table.
    IF it_data IS NOT INITIAL.
      INSERT LINES OF it_data INTO TABLE mt_container.
    ENDIF.
  ENDMETHOD.
  METHOD get_parameter.
    rv_value = VALUE #( mt_container[ name = iv_name ]-value OPTIONAL ).
  ENDMETHOD.
ENDCLASS.
