CLASS zvu_cl_validator DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zvu_if_validate.
    METHODS: constructor IMPORTING iv_id             TYPE zvu_validation_case_id.
  PROTECTED SECTION.
    METHODS: get_customizing IMPORTING iv_step           TYPE zvu_validation_step
                             RETURNING VALUE(rt_valcust) TYPE zvu_tt_valcust.
    DATA: mo_dynamic_if        TYPE REF TO zvu_if_dynamic_if_execute,
          mo_message_processor TYPE REF TO zvu_if_message_processor.
  PRIVATE SECTION.
    DATA: mv_id         TYPE zvu_validation_case_id.

ENDCLASS.



CLASS zvu_cl_validator IMPLEMENTATION.
  METHOD constructor.
    mv_id = iv_id.
    mo_dynamic_if = NEW zvu_cl_dynamic_if( ).
    mo_message_processor = NEW zvu_cl_message_processor( ).
  ENDMETHOD.

  METHOD zvu_if_validate~validate.
    DATA: lv_success       TYPE abap_bool,
          lt_message       TYPE bapiret2_tab,
          lo_obj           TYPE REF TO object,
          lo_checker       TYPE REF TO zvu_if_check,
          lt_rules         TYPE zvu_tt_rules,
          lv_prev_comp     TYPE zvu_complexity,
          lv_prev_seqno    TYPE seqno,
          ls_error_message TYPE zvu_s_message.
    DATA(lt_cust) = get_customizing( iv_step ).
    LOOP AT lt_cust ASSIGNING FIELD-SYMBOL(<ls_cust>).
      CLEAR lv_success.
      IF <ls_cust>-complexity =  zcl_cc_zvu_complexity=>gc_simple.
        "gather all rules for one validation
        INSERT CORRESPONDING #( <ls_cust> ) INTO TABLE lt_rules.
        lv_prev_comp = zcl_cc_zvu_complexity=>gc_simple.
        lv_prev_seqno = <ls_cust>-seqno.
        IF <ls_cust>-message_number IS NOT INITIAL.
          ls_error_message = CORRESPONDING #( <ls_cust> ).
        ENDIF.
      ELSE.
        "check if simple block is finished -> execute simple check
        IF lv_prev_comp = zcl_cc_zvu_complexity=>gc_simple.
          IF mo_dynamic_if->execute( EXPORTING io_container = io_container
                                               it_rules = lt_rules
                                               is_error_message = ls_error_message ) IS INITIAL. "success flag is not filled
            "process message
            mo_message_processor->collect_message( ).
          ENDIF.
        ENDIF.
        CASE <ls_cust>-complexity.
          WHEN zcl_cc_zvu_complexity=>gc_custom.

            ls_error_message = CORRESPONDING #( <ls_cust> ).
            "run method for checking
            TRY.
                CALL METHOD (<ls_cust>-condition_method)
                  EXPORTING
                    io_container     = io_container
                    is_error_message = ls_error_message
                  IMPORTING
                    ev_success       = lv_success.
              CATCH cx_sy_dyn_call_error INTO DATA(lo_ex).
                MESSAGE e004(zvu_validator) WITH lo_ex->get_text( ) INTO DATA(lv_message).
            ENDTRY.
            mo_message_processor->collect_message( ).
          WHEN zcl_cc_zvu_complexity=>gc_complex.

            ls_error_message = CORRESPONDING #( <ls_cust> ).
            CREATE OBJECT lo_obj TYPE (<ls_cust>-condition_method).
            lo_checker ?= lo_obj.
            lo_checker->check( EXPORTING io_container = io_container
                                         is_error_message = ls_error_message
                               IMPORTING ev_success   = lv_success ).
            mo_message_processor->collect_message( ).
        ENDCASE.
      ENDIF.

    ENDLOOP.
    "check if simple block is finished -> execute simple check
    IF lv_prev_comp = zcl_cc_zvu_complexity=>gc_simple.
      IF mo_dynamic_if->execute( EXPORTING io_container = io_container
                                           it_rules = lt_rules
                                           is_error_message = ls_error_message ) IS INITIAL .
        "process message
        mo_message_processor->collect_message( ).
      ENDIF.
    ENDIF.
    et_message = mo_message_processor->release_log( ).
  ENDMETHOD.

  METHOD get_customizing.
    SELECT * FROM zvu_t_valcust
    INTO TABLE @rt_valcust
    WHERE step = @iv_step
      AND id = @mv_id.
  ENDMETHOD.
ENDCLASS.
