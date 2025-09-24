CLASS ltc_export_validator DEFINITION DEFERRED.
CLASS zvu_cl_export_validator  DEFINITION LOCAL FRIENDS ltc_export_validator.
CLASS ltc_export_validator DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    CLASS-DATA: lo_environment_data_base TYPE REF TO if_osql_test_environment.

    METHODS:
      validate FOR TESTING RAISING cx_static_check,
      setup,
      teardown.

    DATA: lo_cut TYPE REF TO zvu_cl_export_validator.
    TYPES: BEGIN OF gtyp_s_export_data,
             vbeln  TYPE vbeln,
             herkl  TYPE herkl,
             edland TYPE land1,
             kunnr  TYPE kunnr,
           END OF gtyp_s_export_data.
ENDCLASS.


CLASS ltc_export_validator IMPLEMENTATION.

  METHOD validate.
    DATA: lo_container TYPE REF TO zvu_cl_prop_container,
          lt_message   TYPE bapiret2_tab,
          ls_export    TYPE gtyp_s_export_data,
          lt_valcust   TYPE zvu_tt_valcust.
    lo_container = NEW #(  ).
    ls_export = VALUE #( vbeln = '123'
                         herkl = 'GE'
                         edland = 'PT'
                         kunnr = '456' ).
    lo_container->set_table( it_data = VALUE #( ( name = 'HERKL'
                                                  value = REF #( ls_export-herkl ) )
                                                ( name = 'EDLAND'
                                                  value = REF #( ls_export-edland ) )
                                                ( name = 'KUNNR'
                                                  value = REF #( ls_export-kunnr ) )
                                              )
                           ).

    lt_valcust = VALUE #( ( id = 'EXPORT'
                            step = zcl_cc_zvu_validation_step=>gc_in
                            seqno = '002'
                            complexity = zcl_cc_zvu_complexity=>gc_custom
                            name = 'KUNNR'
                            condition_method = 'KUNNR_CHECK' )
                          ( id = 'EXPORT'
                            step = zcl_cc_zvu_validation_step=>gc_in
                            seqno = '003'
                            complexity = zcl_cc_zvu_complexity=>gc_simple
                            rule_number = '001'
                            name = 'HERKL'
                            sign = '<>'
                            compared_value_type = zcl_cc_zvu_compared_value_type=>gc_container
                            compared_value = 'EDLAND')
                          ( id = 'EXPORT'
                            step = zcl_cc_zvu_validation_step=>gc_in
                            seqno = '003'
                            complexity = zcl_cc_zvu_complexity=>gc_simple
                            rule_number = '002'
                            name = 'HERKL'
                            sign = 'IS'
                            compared_value_type = zcl_cc_zvu_compared_value_type=>gc_custom
                            compared_value = 'INITIAL')
                         ).
    lo_environment_data_base->insert_test_data( lt_valcust ).

    lo_cut->mo_dynamic_if ?= cl_abap_testdouble=>create( 'zvu_if_dynamic_if_execute' ).
    cl_abap_testdouble=>configure_call( lo_cut->mo_dynamic_if )->returning( abap_false ).

    lo_cut->zvu_if_validate~validate( EXPORTING io_container = lo_container
                                                iv_step = zcl_cc_zvu_validation_step=>gc_in
                                      IMPORTING et_message = lt_message ).
    cl_abap_unit_assert=>assert_equals( msg = '' exp = 'CUSTOM_CHECK' act = lt_message[ 1 ]-message_v1 ).
    cl_abap_unit_assert=>assert_equals( msg = '' exp = 'SIMPLE_CHECK' act = lt_message[ 2 ]-message_v1 ).

  ENDMETHOD.

  METHOD class_setup.
    lo_environment_data_base = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zvu_t_valcust' ) ) ).
  ENDMETHOD.
  METHOD class_teardown.
    lo_environment_data_base->destroy(  ).
  ENDMETHOD.
  METHOD setup.
    lo_cut = NEW #( ).
  ENDMETHOD.
  METHOD teardown.
    FREE lo_cut.
  ENDMETHOD.

ENDCLASS.
