<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    {{ __("Streamer Status") }}
                    <div class="mt-6">
                        <div class="mt-4">
                            @forelse($streamers as $streamer)
                            <p>
                                <a href="{{ $streamer->stream_url }}" target="_blank" class="hover-link">
                                    {{ $streamer->name }}
                                </a>
                            </p>
                            @empty
                            <p>No streamers found.</p>
                            @endforelse
                            <a href="{{ route('streamers.create') }}" class="mt-4 inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-700 text-white font-medium rounded-md">
                                Add Streamer
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout