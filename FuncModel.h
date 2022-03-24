#ifndef FUNCMODEL_H
#define FUNCMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "CmdProc.h"

class FuncModel : public QAbstractListModel
{
    Q_OBJECT
  public:
    //定义数据角色
    int RoleName   = Qt::UserRole;
    int RoleEnable = Qt::UserRole + 1;

    FuncModel(QObject *parent = 0);
    ~FuncModel();
    Q_INVOKABLE void listAllFunc();        //列出所有系统功能
    Q_INVOKABLE void isFunctionAllReady(); //检查系统功能准备好了没

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const;

  private:
    QStringList nameList; //功能列表
    QList<bool> enList;   //使能列表
    CmdProc *proc;
    QMap<QString, bool> *m_map; //图
  signals:
    void funcsAllReady(bool enable);
};

#endif // FUNCMODEL_H
