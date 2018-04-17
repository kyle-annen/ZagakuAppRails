import * as React from 'react';
import * as ReactMarkdown from "react-markdown";

export default class References extends React.Component<any, any> {
  constructor(props) {
    super(props);
  }

  renderReferences(references) {
    return references && references.map(ref => {
      return <ReactMarkdown source={ references.content } />;
    });
  }

  render(){
    return (
      <div>
        <h3>Ongoing References</h3>
        { this.renderReferences(this.props.references)}
      </div>
    )
  }
}