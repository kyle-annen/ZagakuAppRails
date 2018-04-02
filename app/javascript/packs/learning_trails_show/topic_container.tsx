import * as React from 'react';

export default class TopicContainer extends React.Component<any, any> {
  constructor(props){
    super(props);
    this.state = {
      topic_id: 1,
      topic_data: {},
      user_lessons: []
    }
  }

  componentDidMount() {
    const data_node = document.getElementById('learning_trails_show_data');
    const data = JSON.parse(data_node.getAttribute('data'));
    const topic_name = data.name.split(".")[0].split("-").join(" ");
    const capitalized_topic_name = topic_name[0].toUpperCase() + topic_name.slice(1);

    this.setState({
      topic_id: data.id,
      topic_name: capitalized_topic_name,
      topic_summary: data.summary,
    });

    fetch(`/api/v1/topic/${data.id}`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cache': 'no-cache'
      },
      credentials: 'same-origin'
    }).then((response) => {
      return response.json();
    }).then((result) => {
      this.setState({
        topic: result.topic,
        user_lessons: result.user_lessons
      });
    });
  }

  render() {
    return(
      <div className="container">
        <h3 className="topic-page-summary">{this.state.topic_name}</h3>
        <p>{ this.state.topic_summary }</p>
        <p></p>
      </div>
    )
  }
}
