import 'package:flutter/material.dart';
import 'package:app/features/tasks/model/comment_data.dart';

Widget buildTimelineItem(CommentModel item, int index, int totalLength) {
  final isSystem = item.type == 'system';

  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  isSystem ? Colors.blue.shade100 : Colors.grey.shade300,
              child: Icon(
                isSystem ? Icons.history : Icons.person,
                size: 16,
                color: Colors.blue,
              ),
            ),
            if (index != totalLength - 1)
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),

        Expanded(
          child: isSystem ? buildSystemMessage(item) : buildCommentBubble(item),
        ),
      ],
    ),
  );
}

Widget buildSystemMessage(CommentModel item) {
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87),
        children: [
          const TextSpan(
            text: 'System Log ',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(text: item.message),
          TextSpan(
            text: '\n${timeAgo(item.time)}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget buildCommentBubble(CommentModel item) {
  return Column(
    children: [
      Container(
        // margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Name + time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.commentEmail,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Text(
                  timeAgo(item.time),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            // const SizedBox(height: 8),

            /// Message
            Text(
              item.message,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
      SizedBox(height: 8)
    ],
  );
}

Widget buildCommentInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        const Icon(Icons.attach_file, color: Colors.grey),
        const SizedBox(width: 10),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type your reply or @mention colleague...',
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {},
          ),
        )
      ],
    ),
  );
}

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
