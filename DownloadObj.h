#ifndef DOWNLOADOBJ_H
#define DOWNLOADOBJ_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFile>
#include <QTime>
//用于下载aws包
class DownloadObj : public QObject
{
    Q_OBJECT
  public:
    explicit DownloadObj(QObject *parent = nullptr);
    ~DownloadObj();
    Q_INVOKABLE void start(); //开始下载
    const QString &getUrlStr() const;
    void setUrlStr(const QString &newUrlStr);
    void resetUrlStr();

  private:
    //网络类
    QNetworkAccessManager m_netmanager;
    QNetworkReply *m_reply;
    QString urlStr; //网络地址
    QFile *m_file;  //文件
    //计算下载时间用
    QTime m_downloadTimer;
    qreal preTime   = 0.0;
    qreal m_speed   = 0; //下载速度
    qreal prevBytes = 0; //之前一个下载进度的bytes数量

    Q_PROPERTY(QString urlStr READ getUrlStr WRITE setUrlStr RESET resetUrlStr NOTIFY urlStrChanged)

  signals:
    void urlStrChanged();
    void error(QString errorStr);
    void downloadProgress(qint64 bytesRecved, qint64 bytesTotal, qreal speed);
    void downloadFinished();
  private slots:
    void on_readyRead();
    void on_downloadProgress(qint64 bytesRecved, qint64 bytesTotal);
    void on_finished();
};

#endif // DOWNLOADOBJ_H
