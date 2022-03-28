CLASS zcl_saper_products_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor IMPORTING parameters_list TYPE zproducts_report_params_list.

    METHODS fetch_records.

    METHODS display_records.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA parameters_list TYPE zproducts_report_params_list.
    DATA rows TYPE zsaper_products_report_rows.
    DATA alv TYPE REF TO cl_salv_table.

    METHODS get_filter_string RETURNING VALUE(result) TYPE string.

    METHODS select_records IMPORTING filter_string TYPE string.

    METHODS create_alv.

    METHODS set_display_settings.

    METHODS set_functions.

    METHODS set_initial_columns_states.

    METHODS set_colors.

ENDCLASS.



CLASS ZCL_SAPER_PRODUCTS_REPORT IMPLEMENTATION.


  METHOD constructor.

    me->parameters_list = parameters_list.

  ENDMETHOD.


  METHOD create_alv.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = alv
                                CHANGING t_table = rows ).

*        RAISE EXCEPTION TYPE cx_salv_msg.
      CATCH cx_salv_msg INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

  ENDMETHOD.


  METHOD display_records.

    create_alv( ).

    set_display_settings( ).

    set_functions( ).

    set_initial_columns_states( ).

    set_colors( ).

    alv->display( ).

  ENDMETHOD.


  METHOD fetch_records.

    select_records( get_filter_string( ) ).

  ENDMETHOD.


  METHOD get_filter_string.

    TRY.
        result = cl_shdb_seltab=>combine_seltabs(
         it_named_seltabs = VALUE #(
           ( name = 'p~category_id' dref = REF #( parameters_list-categories ) )
           ( name = 'p~supplier_id' dref = REF #( parameters_list-suppliers ) )
         )
       ).
      CATCH cx_shdb_exception INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

    REPLACE ALL OCCURRENCES OF '(' IN result WITH ' ( '.
    REPLACE ALL OCCURRENCES OF ')' IN result WITH ' ) '.

*    data(filter_string) = | (p~category_id IN @parameters_list-categories |
*                         && | AND p~supplier_id IN @parameters_list-suppliers |.

  ENDMETHOD.


  METHOD select_records.

    SELECT p~*, c~category_name, s~company_name AS supplier_name
      FROM zap_products AS p
      JOIN zap_categories AS c ON c~category_id = p~category_id
      JOIN zap_suppliers AS s ON s~supplier_id = p~supplier_id
      UP TO @parameters_list-entries_no ROWS
      INTO CORRESPONDING FIELDS OF TABLE @rows
      WHERE (filter_string).

  ENDMETHOD.


  METHOD set_colors.

    INCLUDE <color>.

    DATA(columns) = alv->get_columns( ).
*    DATA(color_column) = columns->get_column( 'COLOR' ).
*    color_column->set_visible( abap_false ).
    columns->get_column( 'COLOR' )->set_visible( abap_false ).

    CHECK parameters_list-is_custom_colors = abap_true.

*    LVC_T_SCOL type table of LVC_S_SCOL
*    - FNAME
*    - NOKEYCOL
*    - COLOR Type LVC_S_COLO
*    -- COL
*    -- INT
*    -- INV

*    LOOP AT rows INTO DATA(row).
*    LOOP AT rows ASSIGNING FIELD-SYMBOL(<fs>).
    LOOP AT rows REFERENCE INTO DATA(row).
*      row->color = VALUE #( ( color = VALUE #( col = col_key ) fname = 'PRODUCT_ID' )
*                            ( color = VALUE #( col = col_key ) fname = 'PRODUCT_NAME' )
*                            ( color = VALUE #( col = col_total ) fname = 'UNIT_PRICE' ) ).
      row->color = VALUE #( color = VALUE #( col = col_key ) ( fname = 'PRODUCT_ID' )
                                                             ( fname = 'PRODUCT_NAME' )
                            color = VALUE #( col = col_total ) ( fname = 'UNIT_PRICE' ) ).

      IF row->unit_price > 100.
*        DATA(color_value) = VALUE lvc_s_colo( col = col_negative ).
        row->color = VALUE #( ( color = VALUE #( col = col_negative ) ) ).
      ENDIF.
    ENDLOOP.

    TRY.
        columns->set_color_column( 'COLOR' ).
      CATCH cx_salv_data_error INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

  ENDMETHOD.


  METHOD set_display_settings.

    DATA(display) = alv->get_display_settings( ).

    DATA(lines_no) = lines( rows ).

*    data(title) = 'Product (found' + ' ' + lines_no + ' ' + 'records)'.
*    DATA(title) = CONV text70( |Products (found ${ lines_no } records)| ).

*    DATA(title_end_text) = ||.
*    IF lines_no = 1.
*      title_end_text = 'record'.
*    ELSE.
*      title_end_text = 'records'.
*    ENDIF.

    DATA(title_end_text) = COND string( WHEN lines_no = 1 THEN `record` ELSE `records` ).

    display->set_list_header( |Products (found { lines_no } { title_end_text })| ).

  ENDMETHOD.


  METHOD set_functions.

    alv->get_functions( )->set_default( ).

  ENDMETHOD.


  METHOD set_initial_columns_states.

    DATA(columns) = alv->get_columns( ).

    TRY.
        columns->get_column( 'SUPPLIER_NAME' )->set_output_length( 40 ).
      CATCH cx_salv_not_found INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
