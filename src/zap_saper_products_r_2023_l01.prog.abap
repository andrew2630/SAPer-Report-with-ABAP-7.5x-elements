*&---------------------------------------------------------------------*
*&  Include           ZAP_SAPER_PRODUCTS_R_2023_L01
*&---------------------------------------------------------------------*
CLASS lcl_saper_products_report_2023 DEFINITION
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor IMPORTING parameters_list TYPE zproducts_report_params_list.

    METHODS run.

  PRIVATE SECTION.

    DATA param_list TYPE zproducts_report_params_list.
    DATA db_records TYPE zsaper_products_report_rows.
    DATA alv TYPE REF TO cl_salv_table.

    METHODS select_records IMPORTING VALUE(where_statement) TYPE string.

    METHODS display_alv.

    METHODS get_where_statement RETURNING VALUE(result) TYPE string.

ENDCLASS.



CLASS lcl_saper_products_report_2023 IMPLEMENTATION.


  METHOD constructor.

    me->param_list = parameters_list.

  ENDMETHOD.


  METHOD run.

*    DATA(where_statement) = get_where_statement( ).
*
*    select_records( where_statement ).

    select_records( get_where_statement( ) ).

    display_alv( ).

  ENDMETHOD.


  METHOD get_where_statement.

*    DATA(some_table) = VALUE zsaper_products_report_rows( ).

*    DATA(where_statement) = | p~category_id IN @c | &&
*                            | AND p~supplier_id IN @param_list-suppliers |.

*    DATA(named_seltabs) = VALUE cl_shdb_seltab=>tt_named_seltables(
*      ( name = 'p~category_id' dref = REF #( param_list-categories ) )
*      ( name = 'p~supplier_id' dref = REF #( param_list-suppliers ) )
*    ).
*
*    DATA(where_statement) = cl_shdb_seltab=>combine_seltabs(
*      it_named_seltabs = named_seltabs
*    ).

    TRY.
        DATA(where_statement) = cl_shdb_seltab=>combine_seltabs(
          it_named_seltabs = VALUE #(
            ( name = 'p~category_id' dref = REF #( param_list-categories ) )
            ( name = 'p~supplier_id' dref = REF #( param_list-suppliers ) )
          )
        ).
      CATCH cx_shdb_exception INTO DATA(ex).
*        DATA(text) = ex->get_text( ).
*        cl_demo_output=>write( text ).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

    REPLACE ALL OCCURRENCES OF '(' IN where_statement WITH ' ( '.
    REPLACE ALL OCCURRENCES OF ')' IN where_statement WITH ' ) '.

    result = where_statement.

  ENDMETHOD.


  METHOD select_records.

    SELECT p~*, c~category_name, s~company_name AS supplier_name
      FROM zap_products AS p
      JOIN zap_categories AS c ON c~category_id = p~category_id
      JOIN zap_suppliers AS s ON s~supplier_id = p~supplier_id
      UP TO @param_list-entries_no ROWS
      INTO CORRESPONDING FIELDS OF TABLE @db_records
*      WHERE p~category_id IN @param_list-categories
*      AND p~supplier_id IN @param_list-suppliers.
      WHERE (where_statement).

  ENDMETHOD.


  METHOD display_alv.

    INCLUDE <color>.

    " 1. create alv
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = alv
                                CHANGING t_table = db_records ).

      CATCH cx_salv_msg INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

    " 2. set colors
    DATA(columns) = alv->get_columns( ).
    DATA(color_column) = columns->get_column( 'COLOR' ).
    color_column->set_visible( abap_false ).

*    IF param_list-is_default_colors = abap_true.
**    IF param_list-is_custom_colors = abap_false.
*     alv->display( ).
*     return.
*    ENDIF.

    " ....

    DATA(key_color) = VALUE lvc_s_colo( col = col_key ).
    DATA(negative_color) = VALUE lvc_s_colo( col = col_negative ).

    IF param_list-is_custom_colors = abap_true.
*      LOOP AT db_records INTO DATA(db_record).
*      LOOP AT db_records ASSIGNING FIELD-SYMBOL(<db_record>).
      LOOP AT db_records REFERENCE INTO DATA(db_record).
*        db_record->color = VALUE #( ( color = key_color fname = 'PRODUCT_ID' )
*                                    ( color = key_color fname = 'PRODUCT_NAME' ) ).
        db_record->color = VALUE #( color = key_color ( fname = 'PRODUCT_ID' )
                                                      ( fname = 'PRODUCT_NAME' ) ).

        IF db_record->unit_price > 100.
          db_record->color = VALUE #( ( color = negative_color ) ).
        ENDIF.
      ENDLOOP.

      columns->set_color_column( 'COLOR' ).
    ENDIF.

    " 3. display alv
    alv->display( ).

  ENDMETHOD.


ENDCLASS.
