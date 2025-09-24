CLASS ltc_validator DEFINITION DEFERRED.
CLASS zvu_cl_validator  DEFINITION LOCAL FRIENDS ltc_validator.
CLASS ltc_validator DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    CLASS-DATA: lo_environment_data_base TYPE REF TO if_osql_test_environment,
                lo_fm_test_environment   TYPE REF TO if_function_test_environment.

    METHODS:
      validate FOR TESTING RAISING cx_static_check,
      setup,
      teardown.

    DATA: lo_cut TYPE REF TO zvu_cl_validator.
    TYPES: BEGIN OF gtyp_s_export_data,
             vbeln  TYPE vbeln,
             herkl  TYPE herkl,
             edland TYPE land1,
             kunnr  TYPE kunnr,
           END OF gtyp_s_export_data.
ENDCLASS.


CLASS ltc_validator IMPLEMENTATION.

  METHOD validate.
    DATA: lo_container TYPE REF TO zvu_cl_prop_container,
          lt_message   TYPE bapiret2_tab,
          ls_export    TYPE gtyp_s_export_data,
          lt_valcust   TYPE zvu_tt_valcust,
          lo_answer    TYPE REF TO lth_answer,
          ls_bapiret type bapiret2,
          ls_sy like syst,
          ls_message type zvu_s_message.
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
                            seqno = '001'
                            complexity = zcl_cc_zvu_complexity=>gc_complex
                            condition_method = 'LTH_HERKL_CHECK')
*                          ( id = 'EXPORT'
*                            step = zcl_cc_zvu_validation_step=>gc_in
*                            seqno = '002'
*                            complexity = zcl_cc_zvu_complexity=>gc_custom
*                            name = 'KUNNR'
*                            condition_method = 'IS_NOT_INITIAL' ) this part will be implemented in child class
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
    lo_answer = NEW #(  ).
*    cl_abap_testdouble=>configure_call( lo_cut->mo_dynamic_if )->returning( abap_false ).
    cl_abap_testdouble=>configure_call( lo_cut->mo_dynamic_if )->set_answer( lo_answer ).

    data(lo_fm_double) = lo_fm_test_environment->get_double( 'MAP2I_SYST_TO_BAPIRET2' ).
    MESSAGE e002(zvu_validator) INTO DATA(lv_message).
    ls_sy-msgid = sy-msgid.
    ls_sy-msgty = sy-msgty.
    ls_sy-msgno = sy-msgno.
    data(lo_fm_input) = lo_fm_double->create_input_configuration( )->set_importing_parameter( name = 'SYST'
                                                                                              value = ls_sy ).
    ls_bapiret-id = 'ZVU_VALIDATOR'.
    ls_bapiret-message = lv_message.
    ls_bapiret-type = 'E'.
    ls_bapiret-number = '003'.
    data(lo_fm_output) = lo_fm_double->create_output_configuration( )->set_changing_parameter( name = 'BAPIRET2'
                                                                                               value = ls_bapiret ).
    lo_fm_double->configure_call( )->when( lo_fm_input )->then_set_output( lo_fm_output ).
    lo_cut->zvu_if_validate~validate( EXPORTING io_container = lo_container
                                                iv_step = zcl_cc_zvu_validation_step=>gc_in
                                                is_error_message = ls_message
                                      IMPORTING et_message = lt_message ).
*    cl_abap_unit_assert=>assert_equals( msg = 'Wrong validation id in the first message' exp = 'HERKL_CHECK' act = lt_message[ 1 ]-message_v1 ).
*    cl_abap_unit_assert=>assert_equals( msg = 'Wrong validation id in the second message' exp = 'SIMPLE_CHECK' act = lt_message[ 2 ]-message_v1 ).
*    cl_abap_unit_assert=>assert_equals( msg = 'Wrong number for the first message' exp = '003' act = lt_message[ 1 ]-number ).
*    cl_abap_unit_assert=>assert_equals( msg = 'Wrong number for the second message' exp = '003' act = lt_message[ 2 ]-number ).
*    lo_fm_double->verify( )->is_called_times( 2 ).
  ENDMETHOD.

  METHOD class_setup.
    lo_environment_data_base = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zvu_t_valcust' ) ) ).
    lo_fm_test_environment = cl_function_test_environment=>create( VALUE #( ( 'MAP2I_SYST_TO_BAPIRET2' ) ) ).
  ENDMETHOD.
  METHOD class_teardown.
    lo_environment_data_base->destroy(  ).
  ENDMETHOD.
  METHOD setup.
    lo_cut = NEW #( iv_id = 'EXPORT' ).
  ENDMETHOD.
  METHOD teardown.
    FREE lo_cut.
    lo_fm_test_environment->clear_doubles( ).
  ENDMETHOD.

ENDCLASS.
