#pragma once
// MESSAGE PAOTOU_MAVLINK PACKING

#define MAVLINK_MSG_ID_PAOTOU_MAVLINK 12


typedef struct __mavlink_paotou_mavlink_t {
 uint8_t enable; /*<  Test field 1.*/
 uint8_t qian; /*<  Test field 2.*/
 uint8_t hou; /*<  Test field 3.*/
 uint8_t zuo; /*<  Test field 4.*/
 uint8_t you; /*<  Test field 5.*/
 uint8_t tongdao1; /*<  Test field 6.*/
 uint8_t tongdao2; /*<  Test field 7.*/
 uint8_t tongdao3; /*<  Test field 8.*/
 uint8_t tongdao4; /*<  Test field 9.*/
 uint8_t all; /*<  Test field 10.*/
} mavlink_paotou_mavlink_t;

#define MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN 10
#define MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN 10
#define MAVLINK_MSG_ID_12_LEN 10
#define MAVLINK_MSG_ID_12_MIN_LEN 10

#define MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC 91
#define MAVLINK_MSG_ID_12_CRC 91



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_PAOTOU_MAVLINK { \
    12, \
    "PAOTOU_MAVLINK", \
    10, \
    {  { "enable", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_paotou_mavlink_t, enable) }, \
         { "qian", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_paotou_mavlink_t, qian) }, \
         { "hou", NULL, MAVLINK_TYPE_UINT8_T, 0, 2, offsetof(mavlink_paotou_mavlink_t, hou) }, \
         { "zuo", NULL, MAVLINK_TYPE_UINT8_T, 0, 3, offsetof(mavlink_paotou_mavlink_t, zuo) }, \
         { "you", NULL, MAVLINK_TYPE_UINT8_T, 0, 4, offsetof(mavlink_paotou_mavlink_t, you) }, \
         { "tongdao1", NULL, MAVLINK_TYPE_UINT8_T, 0, 5, offsetof(mavlink_paotou_mavlink_t, tongdao1) }, \
         { "tongdao2", NULL, MAVLINK_TYPE_UINT8_T, 0, 6, offsetof(mavlink_paotou_mavlink_t, tongdao2) }, \
         { "tongdao3", NULL, MAVLINK_TYPE_UINT8_T, 0, 7, offsetof(mavlink_paotou_mavlink_t, tongdao3) }, \
         { "tongdao4", NULL, MAVLINK_TYPE_UINT8_T, 0, 8, offsetof(mavlink_paotou_mavlink_t, tongdao4) }, \
         { "all", NULL, MAVLINK_TYPE_UINT8_T, 0, 9, offsetof(mavlink_paotou_mavlink_t, all) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_PAOTOU_MAVLINK { \
    "PAOTOU_MAVLINK", \
    10, \
    {  { "enable", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_paotou_mavlink_t, enable) }, \
         { "qian", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_paotou_mavlink_t, qian) }, \
         { "hou", NULL, MAVLINK_TYPE_UINT8_T, 0, 2, offsetof(mavlink_paotou_mavlink_t, hou) }, \
         { "zuo", NULL, MAVLINK_TYPE_UINT8_T, 0, 3, offsetof(mavlink_paotou_mavlink_t, zuo) }, \
         { "you", NULL, MAVLINK_TYPE_UINT8_T, 0, 4, offsetof(mavlink_paotou_mavlink_t, you) }, \
         { "tongdao1", NULL, MAVLINK_TYPE_UINT8_T, 0, 5, offsetof(mavlink_paotou_mavlink_t, tongdao1) }, \
         { "tongdao2", NULL, MAVLINK_TYPE_UINT8_T, 0, 6, offsetof(mavlink_paotou_mavlink_t, tongdao2) }, \
         { "tongdao3", NULL, MAVLINK_TYPE_UINT8_T, 0, 7, offsetof(mavlink_paotou_mavlink_t, tongdao3) }, \
         { "tongdao4", NULL, MAVLINK_TYPE_UINT8_T, 0, 8, offsetof(mavlink_paotou_mavlink_t, tongdao4) }, \
         { "all", NULL, MAVLINK_TYPE_UINT8_T, 0, 9, offsetof(mavlink_paotou_mavlink_t, all) }, \
         } \
}
#endif

/**
 * @brief Pack a paotou_mavlink message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param enable  Test field 1.
 * @param qian  Test field 2.
 * @param hou  Test field 3.
 * @param zuo  Test field 4.
 * @param you  Test field 5.
 * @param tongdao1  Test field 6.
 * @param tongdao2  Test field 7.
 * @param tongdao3  Test field 8.
 * @param tongdao4  Test field 9.
 * @param all  Test field 10.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_paotou_mavlink_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               uint8_t enable, uint8_t qian, uint8_t hou, uint8_t zuo, uint8_t you, uint8_t tongdao1, uint8_t tongdao2, uint8_t tongdao3, uint8_t tongdao4, uint8_t all)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN];
    _mav_put_uint8_t(buf, 0, enable);
    _mav_put_uint8_t(buf, 1, qian);
    _mav_put_uint8_t(buf, 2, hou);
    _mav_put_uint8_t(buf, 3, zuo);
    _mav_put_uint8_t(buf, 4, you);
    _mav_put_uint8_t(buf, 5, tongdao1);
    _mav_put_uint8_t(buf, 6, tongdao2);
    _mav_put_uint8_t(buf, 7, tongdao3);
    _mav_put_uint8_t(buf, 8, tongdao4);
    _mav_put_uint8_t(buf, 9, all);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#else
    mavlink_paotou_mavlink_t packet;
    packet.enable = enable;
    packet.qian = qian;
    packet.hou = hou;
    packet.zuo = zuo;
    packet.you = you;
    packet.tongdao1 = tongdao1;
    packet.tongdao2 = tongdao2;
    packet.tongdao3 = tongdao3;
    packet.tongdao4 = tongdao4;
    packet.all = all;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_PAOTOU_MAVLINK;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
}

/**
 * @brief Pack a paotou_mavlink message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 *
 * @param enable  Test field 1.
 * @param qian  Test field 2.
 * @param hou  Test field 3.
 * @param zuo  Test field 4.
 * @param you  Test field 5.
 * @param tongdao1  Test field 6.
 * @param tongdao2  Test field 7.
 * @param tongdao3  Test field 8.
 * @param tongdao4  Test field 9.
 * @param all  Test field 10.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_paotou_mavlink_pack_status(uint8_t system_id, uint8_t component_id, mavlink_status_t *_status, mavlink_message_t* msg,
                               uint8_t enable, uint8_t qian, uint8_t hou, uint8_t zuo, uint8_t you, uint8_t tongdao1, uint8_t tongdao2, uint8_t tongdao3, uint8_t tongdao4, uint8_t all)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN];
    _mav_put_uint8_t(buf, 0, enable);
    _mav_put_uint8_t(buf, 1, qian);
    _mav_put_uint8_t(buf, 2, hou);
    _mav_put_uint8_t(buf, 3, zuo);
    _mav_put_uint8_t(buf, 4, you);
    _mav_put_uint8_t(buf, 5, tongdao1);
    _mav_put_uint8_t(buf, 6, tongdao2);
    _mav_put_uint8_t(buf, 7, tongdao3);
    _mav_put_uint8_t(buf, 8, tongdao4);
    _mav_put_uint8_t(buf, 9, all);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#else
    mavlink_paotou_mavlink_t packet;
    packet.enable = enable;
    packet.qian = qian;
    packet.hou = hou;
    packet.zuo = zuo;
    packet.you = you;
    packet.tongdao1 = tongdao1;
    packet.tongdao2 = tongdao2;
    packet.tongdao3 = tongdao3;
    packet.tongdao4 = tongdao4;
    packet.all = all;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_PAOTOU_MAVLINK;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#else
    return mavlink_finalize_message_buffer(msg, system_id, component_id, _status, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#endif
}

/**
 * @brief Pack a paotou_mavlink message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param enable  Test field 1.
 * @param qian  Test field 2.
 * @param hou  Test field 3.
 * @param zuo  Test field 4.
 * @param you  Test field 5.
 * @param tongdao1  Test field 6.
 * @param tongdao2  Test field 7.
 * @param tongdao3  Test field 8.
 * @param tongdao4  Test field 9.
 * @param all  Test field 10.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_paotou_mavlink_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   uint8_t enable,uint8_t qian,uint8_t hou,uint8_t zuo,uint8_t you,uint8_t tongdao1,uint8_t tongdao2,uint8_t tongdao3,uint8_t tongdao4,uint8_t all)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN];
    _mav_put_uint8_t(buf, 0, enable);
    _mav_put_uint8_t(buf, 1, qian);
    _mav_put_uint8_t(buf, 2, hou);
    _mav_put_uint8_t(buf, 3, zuo);
    _mav_put_uint8_t(buf, 4, you);
    _mav_put_uint8_t(buf, 5, tongdao1);
    _mav_put_uint8_t(buf, 6, tongdao2);
    _mav_put_uint8_t(buf, 7, tongdao3);
    _mav_put_uint8_t(buf, 8, tongdao4);
    _mav_put_uint8_t(buf, 9, all);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#else
    mavlink_paotou_mavlink_t packet;
    packet.enable = enable;
    packet.qian = qian;
    packet.hou = hou;
    packet.zuo = zuo;
    packet.you = you;
    packet.tongdao1 = tongdao1;
    packet.tongdao2 = tongdao2;
    packet.tongdao3 = tongdao3;
    packet.tongdao4 = tongdao4;
    packet.all = all;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_PAOTOU_MAVLINK;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
}

/**
 * @brief Encode a paotou_mavlink struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param paotou_mavlink C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_paotou_mavlink_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_paotou_mavlink_t* paotou_mavlink)
{
    return mavlink_msg_paotou_mavlink_pack(system_id, component_id, msg, paotou_mavlink->enable, paotou_mavlink->qian, paotou_mavlink->hou, paotou_mavlink->zuo, paotou_mavlink->you, paotou_mavlink->tongdao1, paotou_mavlink->tongdao2, paotou_mavlink->tongdao3, paotou_mavlink->tongdao4, paotou_mavlink->all);
}

/**
 * @brief Encode a paotou_mavlink struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param paotou_mavlink C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_paotou_mavlink_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_paotou_mavlink_t* paotou_mavlink)
{
    return mavlink_msg_paotou_mavlink_pack_chan(system_id, component_id, chan, msg, paotou_mavlink->enable, paotou_mavlink->qian, paotou_mavlink->hou, paotou_mavlink->zuo, paotou_mavlink->you, paotou_mavlink->tongdao1, paotou_mavlink->tongdao2, paotou_mavlink->tongdao3, paotou_mavlink->tongdao4, paotou_mavlink->all);
}

/**
 * @brief Encode a paotou_mavlink struct with provided status structure
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param status MAVLink status structure
 * @param msg The MAVLink message to compress the data into
 * @param paotou_mavlink C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_paotou_mavlink_encode_status(uint8_t system_id, uint8_t component_id, mavlink_status_t* _status, mavlink_message_t* msg, const mavlink_paotou_mavlink_t* paotou_mavlink)
{
    return mavlink_msg_paotou_mavlink_pack_status(system_id, component_id, _status, msg,  paotou_mavlink->enable, paotou_mavlink->qian, paotou_mavlink->hou, paotou_mavlink->zuo, paotou_mavlink->you, paotou_mavlink->tongdao1, paotou_mavlink->tongdao2, paotou_mavlink->tongdao3, paotou_mavlink->tongdao4, paotou_mavlink->all);
}

/**
 * @brief Send a paotou_mavlink message
 * @param chan MAVLink channel to send the message
 *
 * @param enable  Test field 1.
 * @param qian  Test field 2.
 * @param hou  Test field 3.
 * @param zuo  Test field 4.
 * @param you  Test field 5.
 * @param tongdao1  Test field 6.
 * @param tongdao2  Test field 7.
 * @param tongdao3  Test field 8.
 * @param tongdao4  Test field 9.
 * @param all  Test field 10.
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_paotou_mavlink_send(mavlink_channel_t chan, uint8_t enable, uint8_t qian, uint8_t hou, uint8_t zuo, uint8_t you, uint8_t tongdao1, uint8_t tongdao2, uint8_t tongdao3, uint8_t tongdao4, uint8_t all)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN];
    _mav_put_uint8_t(buf, 0, enable);
    _mav_put_uint8_t(buf, 1, qian);
    _mav_put_uint8_t(buf, 2, hou);
    _mav_put_uint8_t(buf, 3, zuo);
    _mav_put_uint8_t(buf, 4, you);
    _mav_put_uint8_t(buf, 5, tongdao1);
    _mav_put_uint8_t(buf, 6, tongdao2);
    _mav_put_uint8_t(buf, 7, tongdao3);
    _mav_put_uint8_t(buf, 8, tongdao4);
    _mav_put_uint8_t(buf, 9, all);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK, buf, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#else
    mavlink_paotou_mavlink_t packet;
    packet.enable = enable;
    packet.qian = qian;
    packet.hou = hou;
    packet.zuo = zuo;
    packet.you = you;
    packet.tongdao1 = tongdao1;
    packet.tongdao2 = tongdao2;
    packet.tongdao3 = tongdao3;
    packet.tongdao4 = tongdao4;
    packet.all = all;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK, (const char *)&packet, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#endif
}

/**
 * @brief Send a paotou_mavlink message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_paotou_mavlink_send_struct(mavlink_channel_t chan, const mavlink_paotou_mavlink_t* paotou_mavlink)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_paotou_mavlink_send(chan, paotou_mavlink->enable, paotou_mavlink->qian, paotou_mavlink->hou, paotou_mavlink->zuo, paotou_mavlink->you, paotou_mavlink->tongdao1, paotou_mavlink->tongdao2, paotou_mavlink->tongdao3, paotou_mavlink->tongdao4, paotou_mavlink->all);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK, (const char *)paotou_mavlink, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#endif
}

#if MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This variant of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_paotou_mavlink_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t enable, uint8_t qian, uint8_t hou, uint8_t zuo, uint8_t you, uint8_t tongdao1, uint8_t tongdao2, uint8_t tongdao3, uint8_t tongdao4, uint8_t all)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_uint8_t(buf, 0, enable);
    _mav_put_uint8_t(buf, 1, qian);
    _mav_put_uint8_t(buf, 2, hou);
    _mav_put_uint8_t(buf, 3, zuo);
    _mav_put_uint8_t(buf, 4, you);
    _mav_put_uint8_t(buf, 5, tongdao1);
    _mav_put_uint8_t(buf, 6, tongdao2);
    _mav_put_uint8_t(buf, 7, tongdao3);
    _mav_put_uint8_t(buf, 8, tongdao4);
    _mav_put_uint8_t(buf, 9, all);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK, buf, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#else
    mavlink_paotou_mavlink_t *packet = (mavlink_paotou_mavlink_t *)msgbuf;
    packet->enable = enable;
    packet->qian = qian;
    packet->hou = hou;
    packet->zuo = zuo;
    packet->you = you;
    packet->tongdao1 = tongdao1;
    packet->tongdao2 = tongdao2;
    packet->tongdao3 = tongdao3;
    packet->tongdao4 = tongdao4;
    packet->all = all;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_PAOTOU_MAVLINK, (const char *)packet, MAVLINK_MSG_ID_PAOTOU_MAVLINK_MIN_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN, MAVLINK_MSG_ID_PAOTOU_MAVLINK_CRC);
#endif
}
#endif

#endif

// MESSAGE PAOTOU_MAVLINK UNPACKING


/**
 * @brief Get field enable from paotou_mavlink message
 *
 * @return  Test field 1.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_enable(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Get field qian from paotou_mavlink message
 *
 * @return  Test field 2.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_qian(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  1);
}

/**
 * @brief Get field hou from paotou_mavlink message
 *
 * @return  Test field 3.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_hou(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  2);
}

/**
 * @brief Get field zuo from paotou_mavlink message
 *
 * @return  Test field 4.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_zuo(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  3);
}

/**
 * @brief Get field you from paotou_mavlink message
 *
 * @return  Test field 5.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_you(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  4);
}

/**
 * @brief Get field tongdao1 from paotou_mavlink message
 *
 * @return  Test field 6.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_tongdao1(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  5);
}

/**
 * @brief Get field tongdao2 from paotou_mavlink message
 *
 * @return  Test field 7.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_tongdao2(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  6);
}

/**
 * @brief Get field tongdao3 from paotou_mavlink message
 *
 * @return  Test field 8.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_tongdao3(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  7);
}

/**
 * @brief Get field tongdao4 from paotou_mavlink message
 *
 * @return  Test field 9.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_tongdao4(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  8);
}

/**
 * @brief Get field all from paotou_mavlink message
 *
 * @return  Test field 10.
 */
static inline uint8_t mavlink_msg_paotou_mavlink_get_all(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  9);
}

/**
 * @brief Decode a paotou_mavlink message into a struct
 *
 * @param msg The message to decode
 * @param paotou_mavlink C-struct to decode the message contents into
 */
static inline void mavlink_msg_paotou_mavlink_decode(const mavlink_message_t* msg, mavlink_paotou_mavlink_t* paotou_mavlink)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    paotou_mavlink->enable = mavlink_msg_paotou_mavlink_get_enable(msg);
    paotou_mavlink->qian = mavlink_msg_paotou_mavlink_get_qian(msg);
    paotou_mavlink->hou = mavlink_msg_paotou_mavlink_get_hou(msg);
    paotou_mavlink->zuo = mavlink_msg_paotou_mavlink_get_zuo(msg);
    paotou_mavlink->you = mavlink_msg_paotou_mavlink_get_you(msg);
    paotou_mavlink->tongdao1 = mavlink_msg_paotou_mavlink_get_tongdao1(msg);
    paotou_mavlink->tongdao2 = mavlink_msg_paotou_mavlink_get_tongdao2(msg);
    paotou_mavlink->tongdao3 = mavlink_msg_paotou_mavlink_get_tongdao3(msg);
    paotou_mavlink->tongdao4 = mavlink_msg_paotou_mavlink_get_tongdao4(msg);
    paotou_mavlink->all = mavlink_msg_paotou_mavlink_get_all(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN? msg->len : MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN;
        memset(paotou_mavlink, 0, MAVLINK_MSG_ID_PAOTOU_MAVLINK_LEN);
    memcpy(paotou_mavlink, _MAV_PAYLOAD(msg), len);
#endif
}
