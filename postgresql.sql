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
    -- RAISE NOTICE 'add function: 1';
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
        modifyTime,
        stamp
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
        now(),
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

CREATE PROCEDURE dbo.ab_test_control_Del(
    INOUT sId_tmp varchar(36),
    IN modifyUser varchar,
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Del';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    DELETE FROM dbo.ab_test_control WHERE sId=sId_tmp;
    error:='00000';
    eInfo:= 'successful delete';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in delete procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Upp(
    INOUT sId_tmp varchar(36),
    IN textBox_tmp varchar(50),
    IN checkBox_tmp BOOLEAN,
    IN dateBox_tmp timestamp with time zone,
    IN richTextBox_tmp varchar(256),
    IN dropDownList_tmp int,
    IN foreignKey_tmp varchar(36),
    IN dropDownTree_tmp int,
    IN numberBox_tmp decimal(18,2),
    IN numberSpinner_tmp int,
    IN timeSpinner_tmp varchar(10),
    IN dateTimeBox_tmp timestamp with time zone,
    IN modifyUser_tmp varchar(36),
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Del';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    Update dbo.ab_test_control Set
        textBox=textBox_tmp,
        checkBox=checkBox_tmp,
        dateBox=dateBox_tmp,
        richTextBox=richTextBox_tmp,
        dropDownList=dropDownList_tmp,
        foreignKey=foreignKey_tmp,
        dropDownTree=dropDownTree_tmp,
        numberBox=numberBox_tmp,
        numberSpinner=numberSpinner_tmp,
        timeSpinner=timeSpinner_tmp,
        dateTimeBox=dateTimeBox_tmp,
        modifyUser=modifyUser_tmp,
        modifyTime=now(),
        stamp=now()
        WHERE sId=sId_tmp;
    error:='00000';
    eInfo:= 'successful update';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in update procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Action(
    IN userId varchar,      -- which user call the stored procedure
    IN userName varchar,    -- user name
    INOUT info jsonb,       -- input of action and details, output of result
    INOUT entity varchar,   -- extra info
    INOUT error varchar,    -- error code
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
    action varchar;
    sId varchar(36);
    rowoutput jsonb;
    -- parameter list
    textBox varchar;
    checkBox boolean;
    dateBox timestamp with time zone;
    richTextBox varchar;
    dropDownList int;
    foreignKey varchar;
    dropDownTree int;
    numberBox decimal(18,2);
    numberSpinner int;
    timeSpinner varchar;
    dateTimeBox timestamp with time zone;
    sTamp timestamp with time zone;
    -- parameter list

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
            -- RAISE NOTICE '%',rowinfo;

            -- parameter assignment
            action := rowinfo->>'action';
            sId := rowinfo->>'sId';
            textBox := rowinfo->>'textBox';
            checkBox := rowinfo->>'checkBox';
            dateBox := rowinfo->>'dateBox';
            richTextBox := rowinfo->>'richTextBox';
            dropDownList := rowinfo->>'dropDownList';
            foreignKey := rowinfo->>'foreignKey';
            dropDownTree := rowinfo->>'dropDownTree';
            numberBox := rowinfo->>'numberBox';
            numberSpinner := rowinfo->>'numberSpinner';
            timeSpinner := rowinfo->>'timeSpinner';
            dateTimeBox := rowinfo->>'dateTimeBox';
            sTamp := rowinfo->>'sTamp';
            -- parameter assignment

            return_error := language;
            return_eInfo := '';
            IF action ='add' Then
                CALL dbo.ab_test_control_Add(
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
                   userName,
                   return_error,
                   return_eInfo);
	        ELSIF action = 'upp' Then
                CALL dbo.ab_test_control_Upp(
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
                   sTamp,
                   return_error,
                   return_eInfo);
	        ELSIF action = 'del' Then
                CALL dbo.ab_test_control_Del(sId,userId,return_error, return_eInfo);
	        ELSE
                return_eInfo := concat('Marked[', action, '] undefined!');
	    	END IF;

            insert into OutInfo
                (action,sId,error,eInfo)
            values(rowinfo->>'action', sId, return_error, return_eInfo);
        END LOOP;

    info := json_agg(OutInfo)
                from (
                select * from OutInfo) as OutInfo;

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


-- text input and output
-- [
--     {
--         "action":"add",
--         "sId":"generated by uuid",
--         "textBox":"textbox1",
--         "checkBox":0,
--         "dateBox":"2020-11-12 04:17:43.635664",
--         "richTextBox":"richTextBox1",
--         "dropDownList":12,
--         "foreignKey":"foreignKey1",
--         "dropDownTree":12,
--         "numberBox":112.3,
--         "numberSpinner":12,
--         "timeSpinner":"timeSpinn",
--         "dateTimeBox":"2020-11-12 04:17:43.635664",
--         "sTamp":"2020-11-12 04:17:43.635664"
--     },
-- [
--     {
--         "sid": "1f9917eb-99b6-4a51-a9d3-30b3d4c84553",
--         "einfo": "successful add",
--         "error": "00000",
--         "action": "add"
--     }
-- ]
-- ]
-- test example
-- CALL dbo.ab_test_control_action(userId=>'120912', userName=> 'wangyifan', info=>'[
--     {
--         "action":"add",
--         "sId":"generated by uuid",
--         "textBox":"textbox2",
--         "checkBox":0,
--         "dateBox":"2020-11-12 04:17:43.635664",
--         "richTextBox":"richTextBox1",
--         "dropDownList":12,
--         "foreignKey":"foreignKey1",
--         "dropDownTree":12,
--         "numberBox":112.3,
--         "numberSpinner":12,
--         "timeSpinner":"timeSpinn",
--         "dateTimeBox":"2020-11-12 04:17:43.635664",
--         "sTamp":"2020-11-12 04:17:43.635664"
--     }]', entity=>'123', error=>'123', eInfo=>'123');

CALL dbo.ab_test_control_action(userId=>'120912', userName=> 'wangyifan', info=>'[
    {
        "action":"del",
        "sId":"1f9917eb-99b6-4a51-a9d3-30b3d4c84553",
        "textBox":"textbox2",
        "checkBox":0,
        "dateBox":"2020-11-12 04:17:43.635664",
        "richTextBox":"richTextBox1",
        "dropDownList":12,
        "foreignKey":"foreignKey1",
        "dropDownTree":12,
        "numberBox":112.3,
        "numberSpinner":12,
        "timeSpinner":"timeSpinn",
        "dateTimeBox":"2020-11-12 04:17:43.635664",
        "sTamp":"2020-11-12 04:17:43.635664"
    }]', entity=>'123', error=>'123', eInfo=>'123');

CREATE TABLE dbo.springTb
(
sId varchar(36) NOT NULL,
pId varchar(36) NULL,
tbType int NULL,
name varchar(50) NULL,
shortName varchar(50) NULL,
description varchar(256) NULL,
descriptionEn varchar(256) NULL,
tbName varchar(50) NULL,
fieldName varchar(50) NULL,
fieldNo int NULL,
isFile smallint NULL,
filePathNo varchar(36) NULL,
storedProcName varchar(256) NULL,
remark varchar NULL,
queue int NULL,
createUser varchar(36) NULL,
createTime timestamp with time zone default now(),
modifyUser varchar(36) NULL,
modifyTime timestamp with time zone default now(),
sTamp varchar NULL
)

COPY dbo.springtb 
FROM '/root/springtb.csv'
csv
HEADER
NULL 'NULL'

CREATE TABLE dbo.springField
(
    sId varchar(36) NOT NULL,
    tbId varchar(36) NULL,
    isField smallint NULL,
    name varchar(50) NULL,
    description varchar(256) NULL,
    descriptionEn varchar(256) NULL,
    fdType varchar(50) NULL,
    length bigint NULL,
    decimal bigint NULL,
    isNullable smallint NULL,
    isUseable smallint NULL,
    isForeignKey smallint NULL,
    fkTbId varchar(36) NULL,
    fkFieldId varchar(36) NULL,
    defaultValue varchar(500) NULL,
    uiType int NULL,
    uiMask varchar(100) NULL,
    uiVisible smallint NULL,
    uiReadOnly smallint NULL,
    uiWidth int NULL,
    uiDefault varchar(200) NULL,
    isAddField smallint NULL,
    isEditField smallint NULL,
    orderType int NULL,
    remark varchar NULL,
    queue int NULL,
    createUser varchar(36) NULL,
    createTime timestamp with time zone NULL,
    modifyUser varchar(36) NULL,
    modifyTime timestamp with time zone NULL,
    sTamp varchar NULL
)