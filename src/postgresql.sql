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
    IN userName varchar,
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Add';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    sId:=uuid_generate_v4();
    RAISE NOTICE 'add function: 1';
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
        creataUserName,
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
        userName,
        now(),
        userId,
        now()
    );
    error:='00000';
    eInfo:= 'successful add';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in add procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Action(
    IN userId varchar,      -- which user call the stored procedure
    IN userName varchar,    -- user name
    INOUT info jsonb,        -- input of action and details, output of result
    INOUT entity varchar,   -- extra info
    INOUT error varchar,        -- error code
	INOUT eInfo varchar     -- error details
)
AS $$

DECLARE
	procName varchar := 'ab_test_control_Action';  --存储过程名称
    language varchar := error; --国家代码
    position bigint := -1;		--错误位置
    return_error varchar;
    return_eInfo varchar;
  	rowinfo jsonb;
  	action varchar(20);
    sId varchar(36):= rowinfo->>'sId';
BEGIN
    --定义返回JSON临时表
    CREATE TEMP TABLE OutInfo 
        (
        action varchar(20),
        sId varchar(36),
        error varchar, 
        eInfo varchar
        );
    FOR rowinfo in SELECT * FROM jsonb_array_elements(info)
        LOOP
            RAISE NOTICE '%',rowinfo;
            return_error := language;
            return_eInfo := '';
            IF rowinfo->>'action'='add' Then
                CALL dbo.ab_test_control_Add(
                   sId ,
                   rowinfo->>'textBox',
                   (rowinfo->>'checkBox')::boolean,
                   (rowinfo->>'dateBox')::timestamp with time zone,
                   rowinfo->>'richTextBox',
                   (rowinfo->>'dropDownList')::int,
                   rowinfo->>'foreignKey',
                   (rowinfo->>'dropDownTree')::int,
                   (rowinfo->>'numberBox')::decimal(18,2),
                   (rowinfo->>'numberSpinner')::int,
                   rowinfo->>'timeSpinner',
                   (rowinfo->>'dateTimeBox')::timestamp with time zone,
                   userId,
                   userName,
                   return_error,
                   return_eInfo);
	        ELSIF action='upp' Then

	        ELSIF action='del' Then
                CALL ab_test_control_Del(sId,userId,return_error);
	        ELSE
                return_eInfo := concat('Marked[', rowinfo->>action, '] undefined!');
	    	END IF;

            insert into OutInfo
                (action,sId,error,eInfo)
            values(action, sId, return_error, return_eInfo);
        END LOOP;

    DROP TABLE OutInfo;
	error:='00000';
    eInfo:= 'successful completion';
    exception
        When Others Then
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in main procedure: ',eInfo);
END;
$$ LANGUAGE plpgsql;