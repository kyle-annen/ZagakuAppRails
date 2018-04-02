import * as React from 'react';

interface ContainerProps {
  title: string
}

export default class ContentContainer extends React.Component<ContainerProps> {
  constructor(props: ContainerProps) {
    super(props);
  }

  render() {
    return(
      <div className="container page-textbox">
        <h4 className="topic-page-summary">{this.props.title}</h4>
        {this.props.children}
      </div>
    )
  }
}
