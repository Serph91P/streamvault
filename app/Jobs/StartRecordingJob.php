<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class StartRecordingJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $streamer;

    /**
     * Create a new job instance.
     *
     * @param  \App\Models\Streamer  $streamer
     * @return void
     */
    public function __construct($streamer)
    {
        $this->streamer = $streamer;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $command = "streamlink --output {$this->streamer->output_path} {$this->streamer->stream_url} best";
        shell_exec($command);
    }
}

