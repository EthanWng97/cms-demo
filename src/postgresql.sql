CREATE or REPLACE PROCEDURE dbo.ab_test_control_Add(
    INOUT sId varchar(36),
    IN textBox varchar(50),
    IN checkBox BOOLEAN,
    IN dateBox timestamp with time zone,
    IN richTextBox varchar(256),
    IN dropDownList int,
    IN foreignKey varchar(36),
    IN dropDownTree int,
    IN numberBox decimal(18,2),
    IN numberSpinner int,
    IN timeSpinner varchar(10),
    IN dateTimeBox timestamp with time zone,
    IN userId varchar(36),
    INOUT error varchar(500)
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Add';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置
    eInfo text;

BEGIN
    sId:=uuid_generate_v4();
    Insert Into dbo.ab_test_control
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
    values
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
        userId,
        now(),
        userId,
        now()
    );
    error:='0';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT;
            error:= concat('error: ',eInfo);
            -- raise notice '异常: %',eInfo;
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Action(
    IN userId varchar,      -- which user call the stored procedure
    IN userName varchar,    -- user name
    INOUT info json,        -- input of action and details, output of result
    INOUT entity varchar,   -- extra info
    INOUT error int,        -- error code
	INOUT eInfo varchar     -- error details
)
AS $$

DECLARE
	procName varchar := 'ab_test_control_Action';  --存储过程名称
    language varchar := error; --国家代码
    position bigint := -1;		--错误位置

    TmpXML xml := CONVERT(xml,xml);
	TmpXMLEntity xml :=CONVERT(xml,xmlEntity);

    StrXML varchar;
    return_info varchar;


    --初始化扩展传出参数-------------------
    xmlEntity varchar:='<dataset><table></table></dataset>';

    return_error varchar(255);
	cur_films CURSOR FOR SELECT * FROM film WHERE release_year = p_year;

	sId varchar(36);
  	textBox varchar(50);
  	checkBox bit;
  	dateBox timestamp with time zone;
  	richTextBox varchar(256);
  	dropDownList int;
  	foreignKey varchar(36);
  	dropDownTree int;
  	numberBox decimal(18,2);
  	numberSpinner int;
  	timeSpinner varchar(10);
  	dateTimeBox timestamp with time zone;
  	sTamp timestamp with time zone;
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
        error int,
        eInfo varchar
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
        return_info := '';
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
                   userId,
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
--                    userId,
--                    sTamp,
--                    return_error);
	    ELSIF action='del' Then
            CALL ab_test_control_Del(sId,userId,return_error);
	    ELSE
          return_error := 'Marked['+action+'] undefined!';
		END IF;

        -- action varchar(20),
        -- sId varchar(36),
        -- error int,
        -- eInfo varchar,

        insert into OutInfo
            (action,sId,error,eInfo)
        values(action, sId, return_error, return_info);
        
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

	error :='0';
Exception
	When Others Then
        get stacked diagnostics eInfo:= MESSAGE_TEXT;
        error:= 'error:%', eInfo;
-- BEGIN CATCH
      --set error='error:'+ERROR_MESSAGE();
--       set error = procName+':'+dbo.SpringSpTranslation_Error(procName,language,999,Convert(varchar(150),position),ERROR_MESSAGE(),'','','');

END;
$$ LANGUAGE plpgsql;