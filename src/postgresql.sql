CREATE or REPLACE PROCEDURE dbo.ab_test_control_Add(
    textBox varchar(50),
    checkBox BOOLEAN,
    dateBox timestamp,
    richTextBox varchar(256),
    dropDownList int,
    foreignKey varchar(36),
    dropDownTree int,
    numberBox decimal(18,2),
    numberSpinner int,
    timeSpinner varchar(10),
    dateTimeBox timestamp,
    createUser varchar(36),
    INOUT error varchar(500),
    INOUT sId varchar(36)
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Add';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置
    errorinfo text;

BEGIN
    sId:='SELECT uuid_generate_v4()';
    Insert Into ab_test_control
       (
       sId,
       textBox,
       checkBox,
       dateBox,
       richTextBox,
       dropDownList,
       foreignKey,
       dropDownTree,
       numberBox,
       numberSpinner,
       timeSpinner,
       dateTimeBox,
       createUser,
       createTime,
       modifyUser,
       modifyTime
       )
    values(
           @sId,
           @textBox,
           @checkBox,
           @dateBox,
           @richTextBox,
           @dropDownList,
           @foreignKey,
           @dropDownTree,
           @numberBox,
           @numberSpinner,
           @timeSpinner,
           @dateTimeBox,
           @createUser,
           sysdatetimeoffset(),
           @createUser,
           sysdatetimeoffset()
          );
    COMMIT;
    error:='0';

exception
    When Others Then
        rollback;
        get stacked diagnostics errorinfo:= MESSAGE_TEXT;
        error:='error:'+errorinfo;
    --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');

END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Action(
    INOUT xml varchar,
    INOUT xmlEntity varchar, 
    INOUT error varchar,
	INOUT errorinfo varchar
)
AS $$

DECLARE
	procName varchar(50):= 'ab_test_control_Action';  --存储过程名称
    language varchar(50) := error; --国家代码
    position bigint := -1;		--错误位置

    TmpXML xml := CONVERT(xml,xml);
	TmpXMLEntity xml :=CONVERT(xml,xmlEntity);

    StrXML varchar;
    info_return varchar;


    --初始化扩展传出参数-------------------
    xmlEntity varchar:='<dataset><table></table></dataset>';

    return_error varchar(255);
	cur_films CURSOR FOR SELECT * FROM film WHERE release_year = p_year;

	sId varchar(36);
  	textBox varchar(50);
  	checkBox bit;
  	dateBox timestamp;
  	richTextBox varchar(256);
  	dropDownList int;
  	foreignKey varchar(36);
  	dropDownTree int;
  	numberBox decimal(18,2);
  	numberSpinner int;
  	timeSpinner varchar(10);
  	dateTimeBox timestamp;
  	sTamp timestamp;
  	xmlinfo xml;
  	info varchar;
  	action varchar(20);
  	ab_test_c_cur CURSOR FOR
         SELECT
        C.value('sId[1]','varchar(36)') as sId,
        C.value('textBox[1]','nvarchar(50)') as textBox,
        C.value('checkBox[1]','bit') as checkBox,
        C.value('dateBox[1]','datetime') as dateBox,
        C.value('richTextBox[1]','nvarchar(256)') as richTextBox,
        C.value('dropDownList[1]','int') as dropDownList,
        C.value('foreignKey[1]','varchar(36)') as foreignKey,
        C.value('dropDownTree[1]','int') as dropDownTree,
        C.value('numberBox[1]','decimal(18,2)') as numberBox,
        C.value('numberSpinner[1]','int') as numberSpinner,
        C.value('timeSpinner[1]','nvarchar(10)') as timeSpinner,
        C.value('dateTimeBox[1]','datetime') as dateTimeBox,
        C.value('sTamp[1]','timestamp') as sTamp,
        T.C.query('info') as xmlinfo,
        C.value('action[1]','nvarchar(20)') as action
    from TmpXML.nodes('/dataset/table/row') as T(C);
	
BEGIN
    --定义@xml返回XML临时表
    CREATE TEMP TABLE  OutInfo 
        (
        action varchar(20),
        sId varchar(36),
        info varchar,
        error varchar
        );
 	OPEN ab_test_c_cur;

		FETCH NEXT FROM ab_test_c_cur INTO
			 sId,
			 textBox,
			 checkBox,
			 dateBox,
			 richTextBox,
			 dropDownList,
			 foreignKey,
			 dropDownTree,
			 numberBox,
			 numberSpinner,
			 timeSpinner,
			 dateTimeBox,
			 sTamp,
			 xmlinfo,
			 action;
		info := CONVERT(varchar,xmlinfo);
		info := replace(info,'<info>','<dataset>');
		info := replace(info,'</info>','</dataset>');


	WHILE fetch_status = 0
	LOOP
        info_return := '';
        return_error := language;
        IF action='add' Then
            CALL ab_test_control_Add(
                   sId ,
                   textBox,
                   checkBox,
                   dateBox,
                   richTextBox,
                   dropDownList,
                   foreignKey,
                   dropDownTree,
                   numberBox,
                   numberSpinner,
                   timeSpinner,
                   dateTimeBox,
                   createUser,
                   return_error);
	    ELSIF action='upp' Then
--             CALL ab_test_control_Upp(
--                    sId,
--                    textBox,
--                    checkBox,
--                    dateBox,
--                    richTextBox,
--                    dropDownList,
--                    foreignKey,
--                    dropDownTree,
--                    numberBox,
--                    numberSpinner,
--                    timeSpinner,
--                    dateTimeBox,
--                    createUser,
--                    sTamp,
--                    return_error);
	    ELSIF action='del' Then
            CALL ab_test_control_Del(sId,createUser,return_error);
	    ELSE
          return_error := 'Marked['+action+'] undefined!';
		END IF;
		
        insert into OutInfo
            (action,sId,info,error)
        values(action, sId, info_return, return_error);
        FETCH NEXT FROM ab_test_c_cur INTO
			 sId,
			 textBox,
			 checkBox,
			 dateBox,
			 richTextBox,
			 dropDownList,
			 foreignKey,
			 dropDownTree,
			 numberBox,
			 numberSpinner,
			 timeSpinner,
			 dateTimeBox,
			 sTamp,
			 xmlinfo,
			 action;
        info = CONVERT(varchar,xmlinfo);
        info = replace(info,'<info>','<dataset>');
        info = replace(info,'</info>','</dataset>');

    END LOOP;
	CLOSE ab_test_c_cur;
	DEALLOCATE ab_test_c_cur;
   
	-- 传出XML执行参数
	-- StrXML := (SELECT *
    -- FROM OutInfo row
    -- for XML AUTO,ELEMENTS,ROOT('table'));
    StrXML := 'select table_to_xml(''OutInfo'', true, true, '''')';
	xml := '<dataset>'+StrXML+'</dataset>';

	error :='0';
Exception
	When Others Then
        get stacked diagnostics errorinfo:= MESSAGE_TEXT;
        error:='error:'+errorinfo;
-- BEGIN CATCH
      --set error='error:'+ERROR_MESSAGE();
--       set error = procName+':'+dbo.SpringSpTranslation_Error(procName,language,999,Convert(varchar(150),position),ERROR_MESSAGE(),'','','');

END;
$$ LANGUAGE plpgsql;