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