#include "attackpillowmodel.h"

#include "monster.h"

AttackPillowModel::AttackPillowModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

QList<AttackPillow *> AttackPillowModel::pillows()
{
    return m_pillows;
}

int AttackPillowModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_pillows.count();
}

QVariant AttackPillowModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_pillows.count())
        return QVariant();

    AttackPillow *pillow = m_pillows.at(index.row());
    if (role == ValueRole) {
        return pillow->count();
    } else if (role == ColorStringRole) {
        return pillow->colorString();
    } else if (role == SpeedRole) {
        return pillow->speed();
    } else if (role == IdRole) {
        return pillow->id();
    } else if (role == SourceXRole) {
        return pillow->sourceMonster()->position().x();
    } else if (role == SourceYRole) {
        return pillow->sourceMonster()->position().y();
    } else if (role == DestinationXRole) {
        return pillow->destinationMonster()->position().x();
    } else if (role == DestinationYRole) {
        return pillow->destinationMonster()->position().y();
    }

    return QVariant();
}

void AttackPillowModel::addPillow(AttackPillow *pillow)
{
    beginInsertRows(index(m_pillows.count()), m_pillows.count(), 1);
    qDebug() << "Add pillow" << pillow->sourceMonster()->id() << " -> " << pillow->destinationMonster()->id() << "to attack pillow monster";
    m_pillows.append(pillow);
    endInsertRows();
}

void AttackPillowModel::removePillow(AttackPillow *pillow)
{
    beginInsertRows(index(indexOf(pillow)), indexOf(pillow), 1);
    qDebug() << "Remove pillow" << pillow->sourceMonster()->id() << " -> " << pillow->destinationMonster()->id() << "from attack pillow monster";
    m_pillows.append(pillow);
    endInsertRows();
}

void AttackPillowModel::clearModel()
{
    beginResetModel();
    m_pillows.clear();
    endResetModel();
}

QHash<int, QByteArray> AttackPillowModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ValueRole] = "value";
    roles[ColorStringRole] = "colorString";
    roles[SpeedRole] = "speed";
    roles[IdRole] = "id";
    roles[SourceXRole] = "sourceX";
    roles[SourceYRole] = "sourceY";
    roles[DestinationXRole] = "destinationX";
    roles[DestinationYRole] = "destinationY";
    return roles;
}

int AttackPillowModel::indexOf(AttackPillow *pillow)
{
    return m_pillows.indexOf(pillow);
}
