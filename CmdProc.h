#ifndef CMDPROC_H
#define CMDPROC_H

#include <QProcess>
#include <QObject>
#include <QSharedPointer>
class CmdProc : public QProcess
{
    Q_OBJECT
  public:
    enum CMD_EXEC_RESULT
    {
        CMD_SUCCESS_START,        // 启动成功
        CMD_ERROR_START,          // 启动失败
        CMD_SUCCESS_EXEC,         // 执行成功
        CMD_ERROR_EXEC,           // 执行失败
        CMD_ERROR_MISSING_BINARY, // 找不到文件
    };
    QSharedPointer<QMap<QString, bool>> ptr; //只能指针
    CmdProc(QObject *parent = 0);

    //执行命令，命令都可以通过这个执行
    void execute(const QString &progPath, const QStringList &args);
    void listFunction();                           //显示所有系统功能
    void enableFunction(const QString &funcName);  //开启系统某个功能
    void enHyperAllInOne();                        //开启hyperV的功能
    void disHyperAllInOne();                       //关闭hyperV的功能
    void disableFunction(const QString &funcName); //禁止系统某个功能
    void installSubSystem(const QString &path);    //安装子系统

    QSharedPointer<QMap<QString, bool>> &getFuncList(); //获取map

  private:
    QString m_stdOutput = "";
    QString m_errOutput = "";

    void initSignals(); //在这里统一初始化信号绑定
  signals:
    void cmdProcessResult(CMD_EXEC_RESULT res);
};

#endif // CMDPROC_H
