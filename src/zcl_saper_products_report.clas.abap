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

    METHODS get_filter_string RETURNING VALUE(result) TYPE string.

    METHODS select_records IMPORTING filter_string TYPE string.

ENDCLASS.



CLASS ZCL_SAPER_PRODUCTS_REPORT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SAPER_PRODUCTS_REPORT->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] PARAMETERS_LIST                TYPE        ZPRODUCTS_REPORT_PARAMS_LIST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    me->parameters_list = parameters_list.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SAPER_PRODUCTS_REPORT->DISPLAY_RECORDS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display_records.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SAPER_PRODUCTS_REPORT->FETCH_RECORDS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_records.

    select_records( get_filter_string( ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_SAPER_PRODUCTS_REPORT->GET_FILTER_STRING
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RESULT                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_filter_string.

    TRY.
        result = cl_shdb_seltab=>combine_seltabs(
         it_named_seltabs = VALUE #(
           ( name = 'p~category_id' dref = REF #( parameters_list-categories ) )
           ( name = 'p~supplier_id' dref = REF #( parameters_list-suppliers ) )
         )
       ).

*        RAISE EXCEPTION TYPE cx_shdb_exception.
      CATCH cx_shdb_exception INTO DATA(ex).
        cl_demo_output=>write( ex->get_text( ) ).
        cl_demo_output=>display( ).
    ENDTRY.

    REPLACE ALL OCCURRENCES OF '(' IN result WITH ' ( '.
    REPLACE ALL OCCURRENCES OF ')' IN result WITH ' ) '.

*    data(filter_string) = | (p~category_id IN @parameters_list-categories |
*                         && | AND p~supplier_id IN @parameters_list-suppliers |.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_SAPER_PRODUCTS_REPORT->SELECT_RECORDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILTER_STRING                  TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_records.

    SELECT p~*, c~category_name, s~company_name AS supplier_name
      FROM zap_products AS p
      JOIN zap_categories AS c ON c~category_id = p~category_id
      JOIN zap_suppliers AS s ON s~supplier_id = p~supplier_id
      UP TO @parameters_list-entries_no ROWS
      INTO CORRESPONDING FIELDS OF TABLE @rows
      WHERE (filter_string).

  ENDMETHOD.
ENDCLASS.
