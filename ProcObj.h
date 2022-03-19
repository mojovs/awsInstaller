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

    const QString &path() const;
    void setPath(const QString &newPath);

  signals:
    void exeFailed();
    void exeSuccess();

    void pathChanged();

  private:
    CmdProc *proc;
    QString m_path; //程序路径

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

  private slots:
    void on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT res);
};

#endif // PROCOBJ_H
