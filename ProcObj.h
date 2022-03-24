#ifndef PROCOBJ_H
#define PROCOBJ_H

#include <QObject>
#include <QProcess>
#include "CmdProc.h"
#include "FuncModel.h"

class ProcObj : public QObject
{
    Q_OBJECT
  public:
    ProcObj(QObject *parent = 0);
    ~ProcObj();
    Q_INVOKABLE void installSubSystem();
    Q_INVOKABLE void enHyper();
    Q_INVOKABLE void disHyper();
    Q_INVOKABLE void adbConnect(); //连接子系统

    Q_INVOKABLE void adbInstallApk(); // adb安装

    const QString &path() const;
    void setPath(const QString &newPath);

    const QString &subIP() const;
    void setSubIP(const QString &newSubIP);

    const QString &apkPath() const;
    void setApkPath(const QString &newApkPath);

  signals:
    void exeFailed();
    void exeSuccess();

    void pathChanged();
    void subIPChanged();
    void adbSubSysInstallS(); // sub子系统安装成功
    void adbConnectSuccess(); // adb连接成贡
    void adbConnectFailed();  // adb连接失败
    void adbApkInstallS();    // apk安装成功
    void adbApkInstallF();    // apk安装蚀本
    void apkPathChanged();

  private:
    CmdProc *proc;
    QString m_path;    //子系统包路径
    QString m_apkPath; //要安装的apk路径
    QString m_subIP;   // subsystem IP:port

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

    Q_PROPERTY(QString subIP READ subIP WRITE setSubIP NOTIFY subIPChanged)

    Q_PROPERTY(QString apkPath READ apkPath WRITE setApkPath NOTIFY apkPathChanged)

  private slots:
    void on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT res);
};

#endif // PROCOBJ_H
